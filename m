Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaI0O7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 10:59:38 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:38511 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbaI0O7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 10:59:37 -0400
Date: Sat, 27 Sep 2014 20:29:24 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: nick <yocto6@gmail.com>
Cc: David Lang <david@lang.hm>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Help Out and Issues with the Community
Message-ID: <20140927145924.GA2413@sudip-PC>
References: <5424BB1E.80605@gmail.com>
 <alpine.DEB.2.02.1409251914420.28845@nftneq.ynat.uz>
 <5425BDFE.6050908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5425BDFE.6050908@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 03:26:54PM -0400, nick wrote:
> 
> 
> On 14-09-25 10:20 PM, David Lang wrote:
> >> Hello Developers,
> >> For the last week or two I have been trying to contact people for help and/or learning in order to help out
> >> more. I am unable to get any emails back from them, I am assuming this is due to my issues with the community.
> >> If someone would like to explain a way to either resolve this or help me me learn the community rules and how
> >> to do things the right way that would be great.
> > 
> > Going over the archives a bit, it looks like there are a lot of people who have taken the time to reply to you.
> > 
> > It looks like you are falling into a common trap of looking at particular bug reports or FIXME items and trying to silence them. But you are doing so without understanding the code or functionality being provided. As a result, you are doing exactly what people are afraid that static checking will result in, a local fix to silence the checker that doesn't actually fix the overall problem.
> > 
> > In addition to the various places you've already been pointed at, I'd suggest that you look at the kernel janitors pages and mailing list (http://kernelnewbies.org/KernelJanitors), the linux-kernel list has a huge membership and a high volume of traffic, so learning as you work here is not always the best thing to do.
> > 
> > David Lang
> David,
> That wasn't my idea, it was to help out and ask questions if I don't understand something first. I will start with kernel janitors and go from their.
> Thanks Nick 

hey nick,
allow me to remind you that few days back you were in the kernelnewbies, and you have tried to send your patches there also. And newbies like us were able to find problems with your patch. if i remember correctly one patch was corrupt , one patch didnt even apply to linux-next, in another patch you could not explain why you have removed an error message.

thanks
sudip


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
