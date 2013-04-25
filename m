Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab3DYMdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:33:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:43681 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab3DYMdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:33:00 -0400
Message-ID: <51792277.8000205@linutronix.de>
Date: Thu, 25 Apr 2013 14:32:55 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Tim Sander <tim.sander@hbm.com>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.4.41-rt55-feat1
References: <1366760662.9609.176.camel@gandalf.local.home> <2156546.QlsX0XyPQz@dabox>
In-Reply-To: <2156546.QlsX0XyPQz@dabox>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 01:14 PM, Tim Sander wrote:
> Hi 
> 
> I just wanted to test this release but it fails to compile with the the 
> following error:
> 
> kernel/hrtimer.c: In function '__hrtimer_start_range_ns':
> kernel/hrtimer.c:1045:7: error: implicit declaration of function 
> 'hrtimer_rt_defer'
> kernel/hrtimer.c: At top level:
> kernel/hrtimer.c:1416:12: error: static declaration of 'hrtimer_rt_defer' 
> follows non-static declaration
> kernel/hrtimer.c:1045:10: note: previous implicit declaration of 
> 'hrtimer_rt_defer' was here
> 
> The kernelconfig is attached.

You do not have CONFIG_HIGH_RES_TIMERS defined. Is this on purpose?

> Best regards
> Tim

Sebastian
