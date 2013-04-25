Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab3DYWUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:20:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:46348 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab3DYWUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:20:06 -0400
Date: Fri, 26 Apr 2013 00:20:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tim Sander <tim.sander@hbm.com>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.4.41-rt55-feat1
In-Reply-To: <3603730.i3rZKahVeu@dabox>
Message-ID: <alpine.LFD.2.02.1304260018470.21884@ionos>
References: <1366760662.9609.176.camel@gandalf.local.home> <2156546.QlsX0XyPQz@dabox> <51792277.8000205@linutronix.de> <3603730.i3rZKahVeu@dabox>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim,

On Thu, 25 Apr 2013, Tim Sander wrote:
> handler. But normally the HR_TIMER is set. So we switched it off on this very 
> purpose. As we also have also PREEMPT_RT_FULL set the proposed solution to 
> allow only PREEMPT_RT_FULL with PREEMPT_RT_FULL set is not an option for us.

-ENOPARSE
