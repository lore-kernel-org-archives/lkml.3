Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3HWHGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:06:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:46214 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab3HWHGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:06:12 -0400
Message-ID: <521709E0.3060505@linutronix.de>
Date: Fri, 23 Aug 2013 09:06:08 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.9-rt5
References: <20130822182127.GA7606@linutronix.de> <20130822145314.32bdb0f9@gandalf.local.home>
In-Reply-To: <20130822145314.32bdb0f9@gandalf.local.home>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 08:53 PM, Steven Rostedt wrote:
>>       - bcache does not compile.
> 
> For now, it may be prudent to just make bcache depend on !PREEMPT_RT.
> 
> I can send a patch if you want.

I was tempted to take one of your two patches. Haven't deiced yet.

> -- Steve

Sebastian
