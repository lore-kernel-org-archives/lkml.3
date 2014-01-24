Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaAXMlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:41:35 -0500
Received: from www.linutronix.de ([62.245.132.108]:54187 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaAXMld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:41:33 -0500
Date: Fri, 24 Jan 2014 13:41:32 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH RT] cpu hotplug: Document why PREEMPT_RT uses a spinlock
Message-ID: <20140124124132.GA10264@linutronix.de>
References: <20131205091652.0523f2c3@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131205091652.0523f2c3@gandalf.local.home>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt | 2013-12-05 09:16:52 [-0500]:

>Document the rational for using a spinlock on PREEMPT_RT in the hotplug
>lock code.
applied.

>Reported-by: Nicholas Mc Guire <der.herr@hofr.at>
>Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>

Sebastian
