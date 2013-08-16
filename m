Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3HPJTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 05:19:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37962 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3HPJTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 05:19:01 -0400
Message-ID: <520DEE5F.70106@oracle.com>
Date: Fri, 16 Aug 2013 17:18:23 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Luigi Semenzato <semenzato@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v6 0/5] zram/zsmalloc promotion
References: <1376459736-7384-1-git-send-email-minchan@kernel.org> <20130814174050.GN2296@suse.de> <20130814185820.GA2753@gmail.com> <20130815171250.GA2296@suse.de> <20130816042641.GA2893@gmail.com> <20130816083347.GD2296@suse.de> <20130816091223.GF2296@suse.de>
In-Reply-To: <20130816091223.GF2296@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On 08/16/2013 05:12 PM, Mel Gorman wrote:
> On Fri, Aug 16, 2013 at 09:33:47AM +0100, Mel Gorman wrote:
>> On Fri, Aug 16, 2013 at 01:26:41PM +0900, Minchan Kim wrote:
>> <SNIP>
>> It'll get even more entertaining if/when someone ever tries
>> to reimplement zcache although since Dan left I do not believe anyone is
>> planning to try.
> 
> I should mention that Bob Liu did some work with zcache recently but is
> now looking like it'll be dropped from staging. I did not look at the
> details and I have no idea if anything else is planned with it.
> 

The plan is like this:
Zcache dropped from staging.
As a result, for swap pages compression using zswap(zram).
For file pages compression using my new implemention of zcache(v3)
mm/zcache.c

If there is requirement we can merge zswap and zcachev3 in future!

-- 
Regards,
-Bob
