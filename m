Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762821AbbA2CpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:45:08 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:41258 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117AbbA2CpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:45:01 -0500
MIME-Version: 1.0
In-Reply-To: <1422453867-17326-1-git-send-email-andrej.skvortzov@gmail.com>
References: <1422453867-17326-1-git-send-email-andrej.skvortzov@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 28 Jan 2015 18:44:39 -0800
Message-ID: <CALCETrUjjt95zP2mAqLANXmuZKWsCF02MKC7UrhSPf9pusF8YA@mail.gmail.com>
Subject: Re: [PATCH] x86/vdso: teach 'make clean' remove vdso64 binaries
To: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 6:04 AM, Andrey Skvortsov
<andrej.skvortzov@gmail.com> wrote:
> After 'make clean' vdso64.so and vdso64.dbg.so were left in arch/x86/vdso/.
>
> Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>

Applied.  Thanks.

--Andy
