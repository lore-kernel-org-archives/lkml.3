Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935036Ab3BNWfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:35:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:40247 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164Ab3BNWfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:35:05 -0500
Date: Thu, 14 Feb 2013 23:35:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tim Sander <tim@krieglstein.org>
cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 3.4.28-rt40 tglx fix imx.c spinlock
In-Reply-To: <16398840.IK9i4U2q2d@dabox>
Message-ID: <alpine.LFD.2.02.1302142334120.22263@ionos>
References: <6003615.pRQnIgKCSn@dabox> <3970144.HqS49ZSYWh@dabox> <alpine.LFD.2.02.1302131828050.22263@ionos> <16398840.IK9i4U2q2d@dabox>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2013, Tim Sander wrote:
> > That's true, but w/o seing the OOM output I can't tell what's
> > exhausting the memory.
> When fuzzing the serial port one probably should switch of sysreq. It seems 
> as if there is a break send somehow and then it selects the OOM option.
> So when switching of MAGIC_SYSRQ the OOMs are gone. So its a non issue.

Amazing that you get the break+oom combo out of that fuzzer!
