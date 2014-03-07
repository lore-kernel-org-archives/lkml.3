Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaCGNQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:16:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:37455 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaCGNQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:16:01 -0500
Date: Fri, 7 Mar 2014 14:15:55 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, John Kacur <jkacur@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.12.9-rt13: BUG: soft lockup
Message-ID: <20140307131555.GD8637@linutronix.de>
References: <52FBF2F1.8040504@localhost>
 <alpine.DEB.2.02.1402132324230.21991@ionos.tec.linutronix.de>
 <52FD4D89.2000207@localhost>
 <alpine.DEB.2.02.1402140053000.21991@ionos.tec.linutronix.de>
 <52FDB71F.2020000@ccrma.stanford.edu>
 <alpine.DEB.2.02.1402141040460.21991@ionos.tec.linutronix.de>
 <52FE6681.8090807@ccrma.stanford.edu>
 <alpine.DEB.2.02.1402191049260.4468@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402191049260.4468@ionos.tec.linutronix.de>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner | 2014-02-19 10:50:29 [+0100]:

>On Fri, 14 Feb 2014, Fernando Lopez-Lezcano wrote:
>> I could try to boot one of the machines into 3.12.xrtyy, replicate the
>> conditions and wait. What should I look for if I can catch this in the act?
>
>dmesg and sysrq-t output would be a good start I guess.

Yeah. Is it possible to use a serial console? It might happen that the
kernel throws something out before it dies but it does not manage to
write it to disk anymore.

>Thanks,
>
>	tglx

Sebastian
