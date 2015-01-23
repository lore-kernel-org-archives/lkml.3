Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbbAWQR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:17:29 -0500
Received: from www.linutronix.de ([62.245.132.108]:37603 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297AbbAWQR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:17:27 -0500
Date: Fri, 23 Jan 2015 17:16:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Beulich <JBeulich@suse.com>
cc: mingo@elte.hu, hpa@zytor.com, james.t.kukunas@linux.intel.com,
        neilb@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/raid6: correctly check for assembler capabilities
In-Reply-To: <54C2148E02000078000588FB@mail.emea.novell.com>
Message-ID: <alpine.DEB.2.11.1501231716090.5526@nanos>
References: <54C2148E02000078000588FB@mail.emea.novell.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Jan Beulich wrote:

> Just like for AVX2 (which simply needs an #if -> #ifdef conversion),
> SSSE3 assembler support should be checked for before using it.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>
> Cc: Neil Brown <neilb@suse.de>
> ---
>  arch/x86/Makefile       |    1 +

For the x86 part:

Acked-by: Thomas Gleixner <tglx@linutronix.de>

This should go through the raid tree.
