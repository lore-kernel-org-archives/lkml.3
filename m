Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaG2T2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 15:28:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33396 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaG2T2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 15:28:49 -0400
Date: Tue, 29 Jul 2014 21:28:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Message-ID: <20140729192843.GP3935@laptop>
References: <20140724212620.GO3935@laptop>
 <13290270.IfKaUSRMLR@vostro.rjw.lan>
 <20140725055847.GQ3935@laptop>
 <20140729192008.GH3711@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729192008.GH3711@ld-irv-0074>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 12:20:08PM -0700, Brian Norris wrote:

> I'm curious what you mean. Are you referring to the fact that its input
> is simply an IRQ number (regardless of whether the IRQ is shared), not
> something that identifies the particular handler (e.g., struct
> irqaction)?

Yes. I know that shared stuff is a massive head-ache, but I feel we
should not introduce primitives that do not work with it.
