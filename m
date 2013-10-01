Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab3JAVJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:09:16 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:41976 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3JAVJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:09:13 -0400
MIME-Version: 1.0
In-Reply-To: <524B3538.9010406@zytor.com>
References: <1380656245-29975-1-git-send-email-keescook@chromium.org>
	<1380656245-29975-2-git-send-email-keescook@chromium.org>
	<524B3538.9010406@zytor.com>
Date: Tue, 1 Oct 2013 14:09:12 -0700
X-Google-Sender-Auth: fDlm9X4fceIawk_1c1RkoE3N14k
Message-ID: <CAGXu5jLiGoc+=xDpXRRCNneVOWKezTAz2WxjpwtpTt8LXTVK2Q@mail.gmail.com>
Subject: Re: [PATCH 1/7] x86, kaslr: move CPU flags out of cpucheck
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Aaron Durbin <adurbin@google.com>,
        Eric Northup <digitaleric@google.com>, Julien Tinnes <jln@google.com>,
        Will Drewry <wad@google.com>, Mathias Krause <minipli@googlemail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 1, 2013 at 1:48 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/01/2013 12:37 PM, Kees Cook wrote:
>> Refactor the CPU flags handling out of the cpucheck routines so that
>> they can be reused by the future ASLR routines (in order to detect CPU
>> features like RDRAND and RDTSC).
>>
>> This reworks has_eflag() and has_fpu() to be used on both 32-bit and
>> 64-bit, and refactors the calls to cpuid to make them PIC-safe on 32-bit.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Please flag the ones that specifically touch the boot code so that is
> clear.  Neither the title or the description makes that at all clear,
> and at first reading is fairly confusing as a result.

Yes, good point. Patch 1/7 should be named "x86, boot: ..."

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
