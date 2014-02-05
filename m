Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbaBEU3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:29:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:57141 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaBEU3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:29:53 -0500
Date: Wed, 5 Feb 2014 21:29:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Rientjes <rientjes@google.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [patch 2/4] x86, apic: Switch wait_for_init_deassert to bool
In-Reply-To: <alpine.DEB.2.02.1402042354010.7839@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1402052129150.24986@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com> <alpine.DEB.2.02.1402042354010.7839@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014, David Rientjes wrote:

> Now that there is only a single wait_for_init_deassert() function, just
> convert the member of struct apic to a bool to determine whether we need
> to wait for init_deassert to become non-zero.
> 
> There are no more callers of default_wait_for_init_deassert(), so fold
> it into the caller.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
