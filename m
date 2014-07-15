Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356AbaGOUKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:10:32 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35716 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546AbaGOUKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:10:25 -0400
MIME-Version: 1.0
In-Reply-To: <1405452395-9296-1-git-send-email-fabf@skynet.be>
References: <1405452395-9296-1-git-send-email-fabf@skynet.be>
Date: Tue, 15 Jul 2014 22:10:24 +0200
Message-ID: <CAFLxGvyaye+hKGv5L9ZuZAwZNb7FaVpg_n-abSGAmPu+YDc+hQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] fs/ubifs/super.c: replace seq_printf by seq_puts
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 9:26 PM, Fabian Frederick <fabf@skynet.be> wrote:
> Fix checkpatch warnings:
> "WARNING: Prefer seq_puts to seq_printf"

Can you explain why seq_puts() is preferred over seq_printf()?

> Cc: Artem Bityutskiy <dedekind1@gmail.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mtd@lists.infradead.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/ubifs/super.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index 3904c85..e5bd068 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
> @@ -424,19 +424,19 @@ static int ubifs_show_options(struct seq_file *s, struct dentry *root)
>         struct ubifs_info *c = root->d_sb->s_fs_info;
>
>         if (c->mount_opts.unmount_mode == 2)
> -               seq_printf(s, ",fast_unmount");
> +               seq_puts(s, ",fast_unmount");
>         else if (c->mount_opts.unmount_mode == 1)
> -               seq_printf(s, ",norm_unmount");
> +               seq_puts(s, ",norm_unmount");
>
>         if (c->mount_opts.bulk_read == 2)
> -               seq_printf(s, ",bulk_read");
> +               seq_puts(s, ",bulk_read");
>         else if (c->mount_opts.bulk_read == 1)
> -               seq_printf(s, ",no_bulk_read");
> +               seq_puts(s, ",no_bulk_read");
>
>         if (c->mount_opts.chk_data_crc == 2)
> -               seq_printf(s, ",chk_data_crc");
> +               seq_puts(s, ",chk_data_crc");
>         else if (c->mount_opts.chk_data_crc == 1)
> -               seq_printf(s, ",no_chk_data_crc");
> +               seq_puts(s, ",no_chk_data_crc");
>
>         if (c->mount_opts.override_compr) {
>                 seq_printf(s, ",compr=%s",
> --
> 1.8.4.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
