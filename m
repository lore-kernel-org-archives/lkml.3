Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbaELEJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 00:09:13 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:46591 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaELEJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 00:09:11 -0400
MIME-Version: 1.0
In-Reply-To: <52A7D5C3.6010300@huawei.com>
References: <52A7D5C3.6010300@huawei.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 11 May 2014 23:08:50 -0500
Message-ID: <CAH2r5muO1YetatwEWW+e+z+jc7TUv9jLn8Dr1dsz0Sqg1ZU-VA@mail.gmail.com>
Subject: Re: [PATCH] fs: cifs: new helper: file_inode(file)
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Dec 10, 2013 at 9:02 PM, Libo Chen <clbchenlibo.chen@huawei.com> wrote:
>
> Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>
> ---
>  fs/cifs/ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 7749230..45cb59b 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -85,7 +85,7 @@ static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
>                 goto out_fput;
>         }
>
> -       src_inode = src_file.file->f_dentry->d_inode;
> +       src_inode = file_inode(src_file.file);
>
>         /*
>          * Note: cifs case is easier than btrfs since server responsible for
> --
> 1.8.2.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
