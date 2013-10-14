Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab3JNUrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:47:24 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:57119 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461Ab3JNUrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:47:20 -0400
MIME-Version: 1.0
In-Reply-To: <525C1BC1.6090501@zytor.com>
References: <20131011013954.GA28902@www.outflux.net>
	<tip-d751c169e9a6f0f853346f1184881422bd10b3c2@git.kernel.org>
	<20131014083035.GA20976@gmail.com>
	<007cdb12-9fc7-4744-8686-695891b926a3@email.android.com>
	<525C1BC1.6090501@zytor.com>
Date: Mon, 14 Oct 2013 13:47:19 -0700
X-Google-Sender-Auth: Ju_5I7xuaT-MKNovzD7jMIi8ZtQ
Message-ID: <CAGXu5j+tQfUpmem85WK5-ootoJM1mCH6BPDr3pfR2sHwoFy_8A@mail.gmail.com>
Subject: Re: [tip:x86/kaslr] x86, relocs: Add more per-cpu gold special cases
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 9:28 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/14/2013 07:19 AM, H. Peter Anvin wrote:
>> My guess is that the 95 addresses are randomized and the 82 address is an address which failed to relocate.
>
>> ffffffff82a04a58 is:
>> ffffffff82a03000 t init_per_cpu__gdt_page
>
>
> Specifically, it looks like the percpu stuff isn't getting set up correctly.

It wouldn't surprise me if there are even more percpu things to fix.
It's the main area we've continued to trip over while working on this
with various linkers. Which linker and version are you seeing this
with?

-Kees

-- 
Kees Cook
Chrome OS Security
