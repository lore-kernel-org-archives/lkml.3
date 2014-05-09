Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbaEIPzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:55:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:37330 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbaEIPzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:55:21 -0400
Date: Fri, 9 May 2014 17:55:15 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: [RFC PATCH RT] netconsole: enable netconsole on PREEMPT_RT
Message-ID: <20140509155515.GJ29014@linutronix.de>
References: <31fa5b74f8e6267f9b7f906c791d1ddf7d550771.1398788759.git.bristot@redhat.com>
 <536256EC.1060909@windriver.com>
 <5367E23B.7060908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5367E23B.7060908@redhat.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Bristot de Oliveira | 2014-05-05 16:10:51 [-0300]:

>Figure out why it was disabled is one objective of this RFC :-).

The patch first appeared in patch-3.2-rt10.patch. Haven't seen it in
v3.0-rt1 nor in in the first v3.2-rcX-rt1. I would assume that it was
something locking specific.
I haven't seen any lockdep splat in current v3.14-RT. Therefore I'm
going to drop that hunk from the patch so it can be enabled again.

Since I don't really know why it was disabled in v3.2 I think it is
best not to backport this change unless someone figures out the real
reason and provides proof that it works in the older kernel as well.

Sebastian
