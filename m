Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbaGaKck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:32:40 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33921 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbaGaKcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:32:39 -0400
MIME-Version: 1.0
In-Reply-To: <1406801136-7861-1-git-send-email-byungchul.park@lge.com>
References: <1406801136-7861-1-git-send-email-byungchul.park@lge.com>
Date: Thu, 31 Jul 2014 12:32:37 +0200
Message-ID: <CAKv+Gu9X9WJKShsx7FranJAowG21uuyTopLSrRyGQhjRY212Jw@mail.gmail.com>
Subject: Re: [PATCH 1/1] fix a typing error in fpsimd_save_partial_state ENDPROC
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: byungchul.park@lge.com, Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 July 2014 12:05,  <byungchul.park@lge.com> wrote:
> From: "byungchul.park" <byungchul.park@lge.com>
>
> commit 190f1ca85d07 (arm64: add support for kernel mode NEON in interrupt context)
> introduced a typing error in fpsimd_save_partial_state ENDPROC.
> fix the typing error.
>
> Signed-off-by: byungchul.park <byungchul.park@lge.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>


> ---
>  arch/arm64/kernel/entry-fpsimd.S |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kernel/entry-fpsimd.S b/arch/arm64/kernel/entry-fpsimd.S
> index d358cca..c44a82f 100644
> --- a/arch/arm64/kernel/entry-fpsimd.S
> +++ b/arch/arm64/kernel/entry-fpsimd.S
> @@ -52,7 +52,7 @@ ENDPROC(fpsimd_load_state)
>  ENTRY(fpsimd_save_partial_state)
>         fpsimd_save_partial x0, 1, 8, 9
>         ret
> -ENDPROC(fpsimd_load_partial_state)
> +ENDPROC(fpsimd_save_partial_state)
>
>  /*
>   * Load the bottom n FP registers.
> --
> 1.7.9.5
>
