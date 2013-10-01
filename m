Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab3JAUtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:49:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54908 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab3JAUta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:49:30 -0400
Message-ID: <524B3538.9010406@zytor.com>
Date: Tue, 01 Oct 2013 13:48:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        kernel-hardening@lists.openwall.com, adurbin@google.com,
        Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com,
        Mathias Krause <minipli@googlemail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH 1/7] x86, kaslr: move CPU flags out of cpucheck
References: <1380656245-29975-1-git-send-email-keescook@chromium.org> <1380656245-29975-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1380656245-29975-2-git-send-email-keescook@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 12:37 PM, Kees Cook wrote:
> Refactor the CPU flags handling out of the cpucheck routines so that
> they can be reused by the future ASLR routines (in order to detect CPU
> features like RDRAND and RDTSC).
> 
> This reworks has_eflag() and has_fpu() to be used on both 32-bit and
> 64-bit, and refactors the calls to cpuid to make them PIC-safe on 32-bit.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Please flag the ones that specifically touch the boot code so that is
clear.  Neither the title or the description makes that at all clear,
and at first reading is fairly confusing as a result.

	-hpa


