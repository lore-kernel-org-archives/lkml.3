Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab3BTWUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:20:06 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:44214 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3BTWUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:20:05 -0500
MIME-Version: 1.0
In-Reply-To: <51254AF8.9040708@oracle.com>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com>
	<CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com>
	<512522CF.1020901@oracle.com>
	<20130220210116.GD3570@htj.dyndns.org>
	<20130220132300.ccffde44.akpm@linux-foundation.org>
	<20130220213701.GE3570@htj.dyndns.org>
	<20130220140551.8017e795.akpm@linux-foundation.org>
	<512549BE.70304@oracle.com>
	<CAOS58YM77VdO9EoH-5LKZ0NBR0d41GE900goqktU29Oi5=Ov8g@mail.gmail.com>
	<51254AF8.9040708@oracle.com>
Date: Wed, 20 Feb 2013 14:20:04 -0800
X-Google-Sender-Auth: z0H42FqH4RjQsZ9OZekHssaLZpw
Message-ID: <CAOS58YMyXtgykA+8DaFLLc7m3Q9TQLfNTfkxty08VRcSEmVxXA@mail.gmail.com>
Subject: Re: [PATCH] posix-timer: don't call idr_find() w/ negative ID
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 2:15 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> Why can the timer be negative in the first place though? Why isn't the timer
> defined as an 'unsigned int' instead of an 'int' so that all values of timer
> would be legitimate?

No idea but it's userland visible thing. No point in arguing about it.

Thanks.

-- 
tejun
