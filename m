Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab3A1WIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 17:08:30 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37216 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748Ab3A1WI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 17:08:27 -0500
Message-ID: <5106F6CA.30705@linux.vnet.ibm.com>
Date: Mon, 28 Jan 2013 16:08:10 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
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
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv3 0/6] zswap: compressed swap caching
References: <1359409767-30092-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1359409767-30092-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012822-5806-0000-0000-00001EDD1D3F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 03:49 PM, Seth Jennings wrote:
> Changelog:
> 
> v3:
> * Dropped the zsmalloc patches from the set, except the promotion patch
>   which has be converted to a rename patch (vs full diff).  The dropped
>   patches have been Acked and are going into Greg's staging tree soon.
> * Separated [PATCHv2 7/9] into two patches since it makes changes for two
>   different reasons (Minchan)
> * Moved ZSWAP_MAX_OUTSTANDING_FLUSHES near the top in zswap.c (Rik)
> * Rebase to v3.8-rc5. linux-next is a little volatile with the
>   swapper_space per type changes which will effect this patchset.

This patchset will apply but not build on v3.8-rc5 without the
zsmalloc patchset here:

https://lkml.org/lkml/2013/1/25/486

The zsmalloc patches don't apply cleanly without this patch:

https://lkml.org/lkml/2013/1/4/298

Nothing has changed functionally from v2, so it would probably be
easier to do any testing from that version.  However, if you want to
apply this latest version, those are the prerequisite patches.

Or your can pull from here:

git://github.com/spartacus06/linux.git zswap-v3

Seth





