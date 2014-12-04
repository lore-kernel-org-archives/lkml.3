Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaLDCXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 21:23:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55044 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaLDCXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 21:23:22 -0500
MIME-Version: 1.0
In-Reply-To: <1417643197-16986-1-git-send-email-bp@alien8.de>
References: <1417643197-16986-1-git-send-email-bp@alien8.de>
Date: Thu, 4 Dec 2014 10:23:14 +0800
Message-ID: <CACVXFVMariDPBoudg7xMDmqcHppbHZ8q1dbpWiDtrkb6VGCN_A@mail.gmail.com>
Subject: Re: [PATCH] firmware: Correct function name in comment
From: Ming Lei <ming.lei@canonical.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 5:46 AM, Borislav Petkov <bp@alien8.de> wrote:
> From: Borislav Petkov <bp@suse.de>
>
> Use the correct function name in the kernel-doc comment above it.
>
> Cc: Ming Lei <ming.lei@canonical.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  drivers/base/firmware_class.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 3d785ebb48d3..23d19a680524 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -1195,7 +1195,7 @@ request_firmware(const struct firmware **firmware_p, const char *name,
>  EXPORT_SYMBOL(request_firmware);
>
>  /**
> - * request_firmware: - load firmware directly without usermode helper
> + * request_firmware_direct: - load firmware directly without usermode helper
>   * @firmware_p: pointer to firmware image
>   * @name: name of firmware file
>   * @device: device for which firmware is being loaded

Acked-by: Ming Lei <ming.lei@canonical.com>

Thanks,
