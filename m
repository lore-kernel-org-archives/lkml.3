Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537Ab3BLRdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:33:17 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59369 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329Ab3BLRdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:33:16 -0500
MIME-Version: 1.0
In-Reply-To: <511A7892.4020407@zytor.com>
References: <20130209110031.GA17833@n2100.arm.linux.org.uk>
 <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org>
 <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com>
 <5119C34B.70207@zytor.com> <CAMe9rOrTLGJvO+Z8kCG3gmOuW-Yq2Ex9WMfJZ5wmZcbz+zm94Q@mail.gmail.com>
 <CA+55aFwMr8pDfj+wuv=-tUFqZQOhnqkwC7tVq-S=4MGGWiqz1A@mail.gmail.com> <511A7892.4020407@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Feb 2013 09:32:54 -0800
X-Google-Sender-Auth: O6XV7izWg8_l2qCfeThPejMKVCM
Message-ID: <CA+55aFz=OnntmRvi6geuL7ccC6ncwQ7NvURDcwu87BkpS3H0TQ@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user() warnings
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 9:14 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> No, I think what he is talking about it this bit:

Ok, I agree that the bitfield code actually looks cleaner.

That said, maybe gcc has an easier time using a few odd builtins and
magic typeof's. But at least the bitfield trick looks half-way
portable..

                 Linus
