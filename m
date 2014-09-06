Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaIFTBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 15:01:19 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:61631 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaIFTBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 15:01:18 -0400
MIME-Version: 1.0
In-Reply-To: <1410028833-31840-1-git-send-email-marcel@holtmann.org>
References: <1410028833-31840-1-git-send-email-marcel@holtmann.org>
Date: Sat, 6 Sep 2014 21:01:17 +0200
Message-ID: <CANq1E4QFLW3RdNTnQmmyiDNDQg-m5zCP_mL1tRJuRD=cZtW8Xw@mail.gmail.com>
Subject: Re: [PATCH] memfd: Add memfd.h to uapi headers
From: David Herrmann <dh.herrmann@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sat, Sep 6, 2014 at 8:40 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> It seems like a good idea to actually expose include/uapi/linux/memfd.h
> so that it gets installed and can be used by userspace.
>
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Already in -mmots, will probably be pulled by Linus next week:

http://ozlabs.org/~akpm/mmots/broken-out/shm-add-memfdh-to-uapi-export-list.patch

Thanks
David

> ---
>  include/uapi/linux/Kbuild | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
> index 24e9033f8b3f..939df6973102 100644
> --- a/include/uapi/linux/Kbuild
> +++ b/include/uapi/linux/Kbuild
> @@ -240,6 +240,7 @@ header-y += matroxfb.h
>  header-y += mdio.h
>  header-y += media.h
>  header-y += mei.h
> +header-y += memfd.h
>  header-y += mempolicy.h
>  header-y += meye.h
>  header-y += mic_common.h
> --
> 1.9.3
>
