Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3HPJNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 05:13:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29190 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3HPJNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 05:13:08 -0400
Message-ID: <520DED04.2030605@oracle.com>
Date: Fri, 16 Aug 2013 17:12:36 +0800
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
References: <1376459736-7384-1-git-send-email-minchan@kernel.org> <20130814174050.GN2296@suse.de> <20130814185820.GA2753@gmail.com> <20130815171250.GA2296@suse.de> <20130816042641.GA2893@gmail.com> <20130816083347.GD2296@suse.de>
In-Reply-To: <20130816083347.GD2296@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On 08/16/2013 04:33 PM, Mel Gorman wrote:
> 
> I already said I recognise it has a large number of users in the field
> and users count a lot more than me complaining. If it gets promoted then
> I expect it will be on those grounds.
> 
> My position is that I think it's a bad idea because it is clear there is no
> plan or intention of ever brining zram and zswap together. Instead we are
> to have two features providing similar functionality with zram diverging
> further from zswap.  Ultimately I believe this will increase maintenance
> headaches. It'll get even more entertaining if/when someone ever tries
> to reimplement zcache although since Dan left I do not believe anyone is
> planning to try. I will not be acking this series but there many be enough

I already reimplemented zcache based on mm/zbud.c.
http://thread.gmane.org/gmane.linux.kernel.mm/104824

I'll pay more attention to the problems of zswap as you mentioned.

> developers that are actually willing to maintain a duel zram/zswap mess
> to make it happen anyway.
> 

-- 
Regards,
-Bob
