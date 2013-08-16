Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab3HPMsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:48:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3HPMsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:48:01 -0400
Date: Fri, 16 Aug 2013 05:49:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bob Liu <bob.liu@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Luigi Semenzato <semenzato@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v6 0/5] zram/zsmalloc promotion
Message-ID: <20130816124938.GA15291@kroah.com>
References: <1376459736-7384-1-git-send-email-minchan@kernel.org>
 <20130814174050.GN2296@suse.de>
 <20130814185820.GA2753@gmail.com>
 <20130815171250.GA2296@suse.de>
 <20130816042641.GA2893@gmail.com>
 <20130816083347.GD2296@suse.de>
 <20130816091223.GF2296@suse.de>
 <520DEE5F.70106@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520DEE5F.70106@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 05:18:23PM +0800, Bob Liu wrote:
> Hi Mel,
> 
> On 08/16/2013 05:12 PM, Mel Gorman wrote:
> > On Fri, Aug 16, 2013 at 09:33:47AM +0100, Mel Gorman wrote:
> >> On Fri, Aug 16, 2013 at 01:26:41PM +0900, Minchan Kim wrote:
> >> <SNIP>
> >> It'll get even more entertaining if/when someone ever tries
> >> to reimplement zcache although since Dan left I do not believe anyone is
> >> planning to try.
> > 
> > I should mention that Bob Liu did some work with zcache recently but is
> > now looking like it'll be dropped from staging. I did not look at the
> > details and I have no idea if anything else is planned with it.
> > 
> 
> The plan is like this:
> Zcache dropped from staging.

It's already gone in linux-next and will show up as deleted in 3.12-rc1.

greg k-h
