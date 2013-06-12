Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3FLG17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 02:27:59 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:54935 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3FLG16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 02:27:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130611185846.GA23707@www.outflux.net>
References: <20130611185846.GA23707@www.outflux.net>
Date: Wed, 12 Jun 2013 09:27:57 +0300
X-Google-Sender-Auth: 7qVBsMwdmjuj9tHe5ABl5nM3jkQ
Message-ID: <CAOJsxLHW6JE81hBWM2UEWbCLQtyhRok0YWtF=CRPBjTbfYagXw@mail.gmail.com>
Subject: Re: [PATCH] x86, relocs: move ELF relocation handling to C
From: Pekka Enberg <penberg@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86 maintainers <x86@kernel.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kees,

On Tue, Jun 11, 2013 at 9:58 PM, Kees Cook <keescook@chromium.org> wrote:
> Moves the relocation handling into C, after decompression. This requires
> that the decompressed size is passed to the decompression routine as
> well so that relocations can be found. Only kernels that need relocation
> support will use the code.
>
> Based on work by Neill Clift and Michael Davidson.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

How does the kernel benefit from this? Are there problems with the current
assembly code? Are you planning to improve the relocation code?

                        Pekka
