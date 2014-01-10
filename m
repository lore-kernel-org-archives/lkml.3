Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbaAJLQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:16:30 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:64955 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaAJLQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:16:28 -0500
MIME-Version: 1.0
In-Reply-To: <20140110100604.GA12077@pd.tnic>
References: <20131231192106.GA22535@phenom.dumpdata.com>
	<52C347F0.8070902@zytor.com>
	<52CD022E.9040107@halfdog.net>
	<52CD8E10.3010204@zytor.com>
	<20140108193655.GD5098@pd.tnic>
	<52CDC316.4050503@halfdog.net>
	<52CDD3AE.4030301@zytor.com>
	<20140109225815.GI11594@pd.tnic>
	<CA+55aFxQnY_PCG_n4=0w-VG=YLXL-yr7oMxyy0WU2gCBAf3ydg@mail.gmail.com>
	<52CF573F.8030300@zytor.com>
	<20140110100604.GA12077@pd.tnic>
Date: Fri, 10 Jan 2014 19:16:24 +0800
X-Google-Sender-Auth: 5MZIQDK9BoIWIqyB5PkTa-OOQrM
Message-ID: <CA+55aFxkxx-AwF2Tw3_T9uFaA7N+q9qPuv7JP3dEDv9mNP2SuQ@mail.gmail.com>
Subject: Re: Sanitize CPU-state when switching tasks (was sanitize CPU-state
 when switching from virtual-8086 mode to other task)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, halfdog <me@halfdog.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 6:06 PM, Borislav Petkov <bp@alien8.de> wrote:
>
> Tested-by: Borislav Petkov <bp@suse.de>

Ok, good.

Peter, do you want to take it (feel free to add my sign-off), or
should I just commit it?

Also, is there a way to have a "likely not true" version of that
"static_cpu_has()"? There seems to be no way to make the non-K7/K8
case the fallthrough code.. Not that this is likely that
performance-critical, but..

                Linus
