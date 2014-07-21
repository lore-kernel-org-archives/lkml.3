Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbaGUMZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:25:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853AbaGUMZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:25:27 -0400
Message-ID: <53CD06AC.1000408@redhat.com>
Date: Mon, 21 Jul 2014 14:25:16 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests 0/3] x86: Test rflags.rf clearing/setting
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il> <1405942794-22681-1-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1405942794-22681-1-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/07/2014 13:39, Nadav Amit ha scritto:
> This series of patches introduces checks for rflags.rf and whether it is
> cleared after emulation, and set correctly.  The last (third) patch fails even
> with recent fixes, since there is no easy way for the hypervisor to determine
> whether any iteration of rep-string was executed before. RFLAGS.RF should be
> cleared before the first iteration, and set otherwise.
> 
> Nadav Amit (3):
>   x86: Check rflags.rf is cleared after emulation
>   x86: Test rflags.rf is set upon faults
>   x86: Check RFLAGS.RF on interrupt during REP-str
> 
>  lib/x86/desc.c | 14 +++++++++++---
>  lib/x86/desc.h |  1 +
>  x86/eventinj.c | 16 ++++++++++++++++
>  x86/idt_test.c | 13 +++++++++----
>  x86/realmode.c |  3 ++-
>  5 files changed, 39 insertions(+), 8 deletions(-)
> 

I applied patch 1.

Paolo
