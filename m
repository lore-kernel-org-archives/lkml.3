Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaKKC60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 21:58:26 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:59317 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaKKC6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 21:58:24 -0500
MIME-Version: 1.0
In-Reply-To: <1415653764-22162-2-git-send-email-cernekee@gmail.com>
References: <1415653764-22162-1-git-send-email-cernekee@gmail.com> <1415653764-22162-2-git-send-email-cernekee@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 10 Nov 2014 20:58:03 -0600
Message-ID: <CAH2r5muVhqeY0CBigmfRheFj1n5+w8R0D46uiU6XnWWFitOabA@mail.gmail.com>
Subject: Re: [PATCH 2/2] [CIFS] Update MAINTAINERS entry
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged into cifs-2.6.git

(and reviewing your other patch)

On Mon, Nov 10, 2014 at 3:09 PM, Kevin Cernekee <cernekee@gmail.com> wrote:
> Update link to point to Steve's current tree on git.samba.org.  Remove
> link to the old patchwork instance which shows no new patches since 2010.
>
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
>  MAINTAINERS | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b36a4f0..4d8154d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2519,8 +2519,7 @@ M:        Steve French <sfrench@samba.org>
>  L:     linux-cifs@vger.kernel.org
>  L:     samba-technical@lists.samba.org (moderated for non-subscribers)
>  W:     http://linux-cifs.samba.org/
> -Q:     http://patchwork.ozlabs.org/project/linux-cifs-client/list/
> -T:     git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
> +T:     git git://git.samba.org/sfrench/cifs-2.6.git
>  S:     Supported
>  F:     Documentation/filesystems/cifs/
>  F:     fs/cifs/
> --
> 2.1.1
>



-- 
Thanks,

Steve
