Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3ARVBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:01:49 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:62958 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab3ARVBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:01:47 -0500
MIME-Version: 1.0
In-Reply-To: <1354529949-8483-1-git-send-email-dinggnu@gmail.com>
References: <1354529949-8483-1-git-send-email-dinggnu@gmail.com>
Date: Fri, 18 Jan 2013 22:01:47 +0100
X-Google-Sender-Auth: c_ko9MpDbkJORydNkY94f89jAzc
Message-ID: <CAM3j68oEfufFht7Rv3fWvMwS=QCfqv2J=HakKLHd1=LHUJeprA@mail.gmail.com>
Subject: Re: [PATCH] scsi:gdth.c: fix compilation warning
From: Cong Ding <dinggnu@gmail.com>
To: JBottomley@parallels.com, Achim Leubner <achim_leubner@adaptec.com>
Cc: linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cong Ding <dinggnu@gmail.com>, sfr@canb.auug.org.au,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, is this still in the queue or...?

- cong

On Mon, Dec 3, 2012 at 11:19 AM, Cong Ding <dinggnu@gmail.com> wrote:
> We do not allow old-style function definition.  Always spell foo(void) if
> a function does not take any parameters.
>
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  drivers/scsi/gdth.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index 5d72274..950c095 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -204,7 +204,7 @@ static char strbuf[MAX_SERBUF+1];
>  #else
>  #define COM_BASE 0x3f8
>  #endif
> -static void ser_init()
> +static void ser_init(void)
>  {
>      unsigned port=COM_BASE;
>
> --
> 1.7.4.5
>
