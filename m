Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaBSJue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:50:34 -0500
Received: from www.linutronix.de ([62.245.132.108]:49243 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbaBSJua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:50:30 -0500
Date: Wed, 19 Feb 2014 10:50:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, John Kacur <jkacur@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.12.9-rt13: BUG: soft lockup
In-Reply-To: <52FE6681.8090807@ccrma.stanford.edu>
Message-ID: <alpine.DEB.2.02.1402191049260.4468@ionos.tec.linutronix.de>
References: <52FBF2F1.8040504@localhost> <alpine.DEB.2.02.1402132324230.21991@ionos.tec.linutronix.de> <52FD4D89.2000207@localhost> <alpine.DEB.2.02.1402140053000.21991@ionos.tec.linutronix.de> <52FDB71F.2020000@ccrma.stanford.edu>
 <alpine.DEB.2.02.1402141040460.21991@ionos.tec.linutronix.de> <52FE6681.8090807@ccrma.stanford.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014, Fernando Lopez-Lezcano wrote:
> I could try to boot one of the machines into 3.12.xrtyy, replicate the
> conditions and wait. What should I look for if I can catch this in the act?

dmesg and sysrq-t output would be a good start I guess.

Thanks,

	tglx
