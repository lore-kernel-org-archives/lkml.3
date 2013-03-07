Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837Ab3CGVYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:24:17 -0500
Received: from www.sr71.net ([198.145.64.142]:40289 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758563Ab3CGVYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:24:16 -0500
Message-ID: <5139057C.8030501@sr71.net>
Date: Thu, 07 Mar 2013 13:24:12 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
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
        Joe Perches <joe@perches.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv7 4/8] zswap: add to mm/
References: <1362585143-6482-1-git-send-email-sjenning@linux.vnet.ibm.com> <1362585143-6482-5-git-send-email-sjenning@linux.vnet.ibm.com> <5138E3C7.9080205@sr71.net> <513904F2.50607@linux.vnet.ibm.com>
In-Reply-To: <513904F2.50607@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 01:21 PM, Seth Jennings wrote:
>> > Where does the order-1 requirement come from by the way?
> Unsafe LZO compression
> (http://article.gmane.org/gmane.linux.kernel.mm/95460)
> 
> Forgot to put in the comment for v7.

I think kmalloc() makes sense there too.
