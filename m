Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab3FMMj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:39:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37020 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab3FMMj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:39:27 -0400
Message-ID: <51B9BC5E.6060407@oracle.com>
Date: Thu, 13 Jun 2013 20:34:38 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@sr71.net>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCHv13 0/4] zswap: compressed swap caching
References: <1370291585-26102-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1370291585-26102-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On 06/04/2013 04:33 AM, Seth Jennings wrote:
> This is the latest version of the zswap patchset for compressed swap caching.
> This is submitted for merging into linux-next and inclusion in v3.11.
> 

Have you noticed that pool_pages >> stored_pages, like this:
[root@ca-dev32 zswap]# cat *
0
424057
99538
0
2749448
0
24
60018
16837
[root@ca-dev32 zswap]# cat pool_pages
97372
[root@ca-dev32 zswap]# cat stored_pages
53701
[root@ca-dev32 zswap]#

I think it's unreasonable to use more pool pages than stored pages!

Regards,
-Bob
