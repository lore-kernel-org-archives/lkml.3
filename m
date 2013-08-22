Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab3HVSYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:24:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:44268 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3HVSYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:24:24 -0400
Date: Thu, 22 Aug 2013 20:24:23 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.9-rt5
Message-ID: <20130822182423.GA8685@linutronix.de>
References: <20130822182127.GA7606@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130822182127.GA7606@linutronix.de>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior | 2013-08-22 20:21:27 [+0200]:

>Changes since v3.10.9-rt4
>- swait fixes from Steven. It fixed the issues with CONFIG_RCU_NOCB_CPU
>  where the system suddenly froze and RCU wasn't doing its job 

Also a big thanks to Carsten Emde and Paul E. McKenney for finding and
debugging the problem.

Sebastian
