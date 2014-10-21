Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbaJUTfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:35:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:33095 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbaJUTfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:35:10 -0400
Date: Tue, 21 Oct 2014 21:35:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: "pang.xunlei" <pang.xunlei@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] time: Fix NTP adjustment mult overflow.
In-Reply-To: <CALAqxLVtYeHX0qBkOFjf58opp9ympxbjFa2DsaYx-KOthqQS=w@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1410212133450.5308@nanos>
References: <1412838271-11175-1-git-send-email-pang.xunlei@linaro.org> <alpine.DEB.2.11.1410211210000.5308@nanos> <CALAqxLVtYeHX0qBkOFjf58opp9ympxbjFa2DsaYx-KOthqQS=w@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014, John Stultz wrote:
> On Tue, Oct 21, 2014 at 3:19 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > So you adding this just for correctness reasons, not because you
> > observed the problem in practice?
> 
> This is my understanding.
> 
> I'll work with Xunlei to make further clarifications to the changelog
> to make this more explicit.

Ok. I have no objections to the patch itself, just the changelog made
my brain go into spiral mode ...

Thanks,

	tglx
