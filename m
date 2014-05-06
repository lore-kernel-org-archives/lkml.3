Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbaEFStI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:49:08 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:36298 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbaEFStF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:49:05 -0400
MIME-Version: 1.0
In-Reply-To: <1399388179-7647-1-git-send-email-emilgoode@gmail.com>
References: <1399388179-7647-1-git-send-email-emilgoode@gmail.com>
Date: Tue, 6 May 2014 11:49:04 -0700
Message-ID: <CACwgvgU7xC0zzgByh-C6Nh6kwgrtHVRih40YQU4-LLnBPHgn1g@mail.gmail.com>
Subject: Re: [PATCH] staging: lustre: remove unused variables
From: Fredrick Prashanth John Berchmans <fredrickprashanth@gmail.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 7:56 AM, Emil Goode <emilgoode@gmail.com> wrote:
> The following commit left some unused variables behind.
>
> commit 80db2734acbc78db12798cfb611d6acc7fe389e6
> Author: Fredrick John Berchmans <fredrickprashanth@gmail.com>
> Date:   Fri May 2 19:50:15 2014 -0700
>
>     staging: lustre use kernel socket sockopt apis
>
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
>  drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c |    2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
> index 4153b4a..ac3a444 100644
> --- a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
> +++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
> @@ -46,10 +46,8 @@
>  int
>  libcfs_sock_ioctl(int cmd, unsigned long arg)
>  {
> -       mm_segment_t    oldmm = get_fs();
>         struct socket  *sock;
>         int          rc;
> -       struct file    *sock_filp;
>
>         rc = sock_create (PF_INET, SOCK_STREAM, 0, &sock);
>         if (rc != 0) {
> --
> 1.7.10.4
>

Hi Emil,

I have already submitted a patch for this.

Thanks,
Fredrick
