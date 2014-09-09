Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbaIIMua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:50:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:52616 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbaIIMu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:50:29 -0400
Date: Tue, 9 Sep 2014 14:50:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ted Percival <ted@tedp.id.au>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Christoph Lameter <cl@linux.com>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, apic: Fix unmasked CPU initialization
In-Reply-To: <1410192947-6830-1-git-send-email-ted@tedp.id.au>
Message-ID: <alpine.DEB.2.10.1409091448280.11037@nanos>
References: <1410192947-6830-1-git-send-email-ted@tedp.id.au>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2014, Ted Percival wrote:

> Commit 4ba2968420fa removed the application of the CPU mask resulting
> in a hang when initializing the first CPU at boot:
> 
>   x86: Booting SMP configuration
>   .... node  #0, CPUs:      #1_
> 
> Fixes: 4ba2968420fa ("percpu: Resolve ambiguities in __get_cpu_var/cpumask_var_t")

I can't find that commit in any of my trees.

Thanks,

	tglx
