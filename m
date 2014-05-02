Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaEBJEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:04:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:38149 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaEBJEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:04:51 -0400
Date: Fri, 2 May 2014 11:04:47 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RT 1/2] rwsem-rt: Do not allow readers to nest
Message-ID: <20140502090447.GA9178@linutronix.de>
References: <20140409024700.702797305@goodmis.org>
 <20140409025231.998774075@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140409025231.998774075@goodmis.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt | 2014-04-08 22:47:01 [-0400]:

>From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>
>The readers of mainline rwsems are not allowed to nest, the rwsems in the
>PREEMPT_RT kernel should not nest either.
>
>Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Applied

Sebastian
