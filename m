Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab3JVRhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:37:06 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47066 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab3JVRhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:37:04 -0400
Date: Tue, 22 Oct 2013 18:36:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] mfd: ti_am335x_tscadc: fix spin lock and reg_cache
Message-ID: <20131022173659.GD2620@lee--X1>
References: <1375729845-6992-1-git-send-email-zubair.lutfullah@gmail.com>
 <20130807084054.GA18668@lee--X1>
 <52667A6C.6000301@linutronix.de>
 <20131022160523.GB24024@lee--X1>
 <5266AA0F.1030603@linutronix.de>
 <20131022170621.GB2620@lee--X1>
 <5266B32B.9060605@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5266B32B.9060605@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Oct 2013, Sebastian Andrzej Siewior wrote:

> On 10/22/2013 07:06 PM, Lee Jones wrote:
> > Hmm.. I'm starting to see what you mean.
> > 
> > So what's the point of the read before write then?
> > 
> > Why don't you use the cache all of the time?
> 
> I'm waiting for Zabair for this. The last thing he said is that he is
> going to have a wedding which might involve some off time but then this
> was on the 7th this month.
> Depending how long it takes I start digging myself after I finish some
> other things.

Sorry, I meant in am335x_tsc_se_cl().

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
