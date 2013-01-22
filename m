Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3AVToT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 14:44:19 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:54742 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab3AVToQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 14:44:16 -0500
MIME-Version: 1.0
In-Reply-To: <20130122095021.89432qdbeu32a4sg@www.dalek.fi>
References: <1358787763-1226-1-git-send-email-matt@genesi-usa.com>
 <alpine.LFD.2.02.1301211739470.6300@xanadu.home> <CAKGA1bkQ9e8gmSPz_4csJWjEOKj3ZVqSLijSTRWxgDSaZoYqCA@mail.gmail.com>
 <20130122094614.79031aq5ddrgr2zo@www.dalek.fi> <20130122095021.89432qdbeu32a4sg@www.dalek.fi>
From: Matt Sealey <matt@genesi-usa.com>
Date: Tue, 22 Jan 2013 13:43:54 -0600
Message-ID: <CAKGA1bmJwb94h0SVNW7WZkSYAPWeAUpm86D+SsvnOJ5NSNbe_g@mail.gmail.com>
Subject: Re: [PATCH] crypto: fix FTBFS with ARM SHA1-asm and THUMB2_KERNEL
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Nicolas Pitre <nico@fluxnic.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Russell King <linux@arm.linux.org.uk>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        Dave Martin <dave.martin@linaro.org>,
        David McCullough <david_mccullough@mcafee.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 1:50 AM, Jussi Kivilinna
<jussi.kivilinna@mbnet.fi> wrote:
>
>> There is 'tcrypt' module in crypto/ for quick benchmarking. 'modprobe
>> tcrypt mode=500 sec=1' tests AES in various cipher-modes, using different
>> buffer sizes and outputs results to kernel log.
>>
>
> Actually mode=200 might be better, as mode=500 is for asynchronous
> implementations and might use hardware crypto if such device/module is
> available.

Okeydokey I'll start running some tests..

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
