Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3EMMBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 08:01:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:47293 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab3EMMBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 08:01:46 -0400
Date: Mon, 13 May 2013 14:01:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gerlando Falauto <gerlando.falauto@keymile.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/8] genirq: Support for irq domains in generic irq chip
 - V2
In-Reply-To: <5190C720.50903@keymile.com>
Message-ID: <alpine.LFD.2.02.1305131359290.2863@ionos>
References: <20130506142348.321859745@linutronix.de> <5190C720.50903@keymile.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013, Gerlando Falauto wrote:
> 1) What happened to your initial proposal of renaming gc->mask_cache to
> gc->shared_mask_cache? Does that mean you intend to keep compatibility so
> individual drivers can be updated one at a time?

Yes.
 
> 2) What shall we do with such potential patches for individual drivers, given
> the dependencies on your work? Wait until yours get merged?

I'll provide a branch for the SoC folks, which they can pull into
their tree, so we don't have cross tree dependencies.
 
> Could this cross-posting be the root cause for this whole mess?

No idea, really.
 
Thanks,

	tglx
