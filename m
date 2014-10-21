Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542AbaJUVMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:12:23 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:40237 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998AbaJUVMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:12:22 -0400
MIME-Version: 1.0
In-Reply-To: <1413912653-3269-1-git-send-email-geert@linux-m68k.org>
References: <1413912653-3269-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 21 Oct 2014 14:12:21 -0700
Message-ID: <CAADnVQ+5J+BM3onCUxzX+eL-gDqiJ04vDG4iD+3zbqngcmoqzQ@mail.gmail.com>
Subject: Re: [PATCH] m68k: Wire up bpf
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 10:30 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  arch/m68k/include/asm/unistd.h      | 2 +-
>  arch/m68k/include/uapi/asm/unistd.h | 1 +
>  arch/m68k/kernel/syscalltable.S     | 1 +
>  3 files changed, 3 insertions(+), 1 deletion(-)

did the tests pass in samples/bpf/test_verifier ?
Thank you for taking care of it.
