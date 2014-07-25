Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbaGYNzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:55:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:57181 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbaGYNzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:55:08 -0400
Date: Fri, 25 Jul 2014 15:55:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
In-Reply-To: <2634160.AMXQm5EuML@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.10.1407251552160.23352@nanos>
References: <20140724212620.GO3935@laptop> <13290270.IfKaUSRMLR@vostro.rjw.lan> <alpine.DEB.2.10.1407251109390.23352@nanos> <2634160.AMXQm5EuML@vostro.rjw.lan>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014, Rafael J. Wysocki wrote:
> If the face of your remark about the level-triggered interrupts that's all moot.

It's not only level. That you notice right away.

But for edge you lose the edge and some devices will wait forever that
their irq is handled. Not fun to debug :)

Thanks,

	tglx
