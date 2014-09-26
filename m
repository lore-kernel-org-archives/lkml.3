Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaIZC11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 22:27:27 -0400
Received: from mail.lang.hm ([64.81.33.126]:37412 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbaIZC1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 22:27:25 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2014 22:27:25 EDT
Date: Thu, 25 Sep 2014 19:20:39 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: nick <yocto6@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Help Out and Issues with the Community
In-Reply-To: <5424BB1E.80605@gmail.com>
Message-ID: <alpine.DEB.2.02.1409251914420.28845@nftneq.ynat.uz>
References: <5424BB1E.80605@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello Developers,
> For the last week or two I have been trying to contact people for help and/or learning in order to help out
> more. I am unable to get any emails back from them, I am assuming this is due to my issues with the community.
> If someone would like to explain a way to either resolve this or help me me learn the community rules and how
> to do things the right way that would be great.

Going over the archives a bit, it looks like there are a lot of people who have 
taken the time to reply to you.

It looks like you are falling into a common trap of looking at particular bug 
reports or FIXME items and trying to silence them. But you are doing so without 
understanding the code or functionality being provided. As a result, you are 
doing exactly what people are afraid that static checking will result in, a 
local fix to silence the checker that doesn't actually fix the overall problem.

In addition to the various places you've already been pointed at, I'd suggest 
that you look at the kernel janitors pages and mailing list 
(http://kernelnewbies.org/KernelJanitors), the linux-kernel list has a huge 
membership and a high volume of traffic, so learning as you work here is not 
always the best thing to do.

David Lang
