Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaKYUYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:24:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:47577 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaKYUYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:24:15 -0500
Date: Tue, 25 Nov 2014 21:24:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rik van Riel <riel@redhat.com>
cc: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>, kvm@vger.kernel.org
Subject: Re: [patch -rt 2/2] KVM: lapic: mark LAPIC timer handler as
 irqsafe
In-Reply-To: <5474D476.3020506@redhat.com>
Message-ID: <alpine.DEB.2.11.1411252123480.3961@nanos>
References: <20141125172108.992070524@redhat.com> <20141125172329.580701786@redhat.com> <5474D476.3020506@redhat.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014, Rik van Riel wrote:
> On 11/25/2014 12:21 PM, Marcelo Tosatti wrote:
> > Since lapic timer handler only wakes up a simple waitqueue,
> > it can be executed from hardirq context.
> > 
> > Reduces average cyclictest latency by 3us.
> 
> Can this patch be merged in the KVM tree, and go
> upstream via Paolo?

Not really as it has RT dependencies ....

Thanks,

	tglx
