Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaBXVN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 16:13:27 -0500
Received: from www.linutronix.de ([62.245.132.108]:60604 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaBXVN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 16:13:26 -0500
Date: Mon, 24 Feb 2014 22:13:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Vrabel <david.vrabel@citrix.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Xen <xen-devel@lists.xenproject.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Xen-devel] [patch 18/26] xen: Use the proper irq functions
In-Reply-To: <530B5624.8080309@citrix.com>
Message-ID: <alpine.DEB.2.02.1402242213030.21251@ionos.tec.linutronix.de>
References: <20140223212703.511977310@linutronix.de> <20140223212738.222412125@linutronix.de> <530B5624.8080309@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, David Vrabel wrote:

> On 23/02/14 21:40, Thomas Gleixner wrote:
> > I really can't understand why people keep adding irq_desc abuse. We
> > have enough proper interfaces. Delete another 14 lines of hackery.
> 
>     generic_handler_irq() already tests for !desc so use this instead
>     of generic_handle_irq_desc().  Use irq_get_irq_data() instead of
>     desc->irq_data.

Fair enough. I was not really in the mood to come up with proper
changelogs :)

> Otherwise,
> 
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> 
> David
> 
