Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbaGAP1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:27:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:32905 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680AbaGAP1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:27:53 -0400
Message-ID: <53B2D378.7010006@infradead.org>
Date: Tue, 01 Jul 2014 08:27:52 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Seunghun Lee <waydi1@gmail.com>, dedekind1@gmail.com,
        adrian.hunter@intel.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] UBIFS: fix some comments
References: <1404225925-3347-1-git-send-email-waydi1@gmail.com>
In-Reply-To: <1404225925-3347-1-git-send-email-waydi1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/14 07:45, Seunghun Lee wrote:
> This patch fixes some comments about return type.
> 
> Signed-off-by: Seunghun Lee <waydi1@gmail.com>
> ---
>  fs/ubifs/recovery.c |    4 ++--
>  fs/ubifs/scan.c     |    5 ++---
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ubifs/recovery.c b/fs/ubifs/recovery.c
> index c14adb2..933dda5 100644
> --- a/fs/ubifs/recovery.c
> +++ b/fs/ubifs/recovery.c
> @@ -629,8 +629,8 @@ static void drop_last_node(struct ubifs_scan_leb *sleb, int *offs)
>   *
>   * This function does a scan of a LEB, but caters for errors that might have
>   * been caused by the unclean unmount from which we are attempting to recover.
> - * Returns %0 in case of success, %-EUCLEAN if an unrecoverable corruption is
> - * found, and a negative error code in case of failure.
> + * Returns the scaned information on success and a negative error code on

                  scanned

> + * failure.
>   */
>  struct ubifs_scan_leb *ubifs_recover_leb(struct ubifs_info *c, int lnum,
>  					 int offs, void *sbuf, int jhead)
> diff --git a/fs/ubifs/scan.c b/fs/ubifs/scan.c
> index 58aa05d..327d84a 100644
> --- a/fs/ubifs/scan.c
> +++ b/fs/ubifs/scan.c
> @@ -131,7 +131,8 @@ int ubifs_scan_a_node(const struct ubifs_info *c, void *buf, int len, int lnum,
>   * @offs: offset to start at (usually zero)
>   * @sbuf: scan buffer (must be c->leb_size)
>   *
> - * This function returns %0 on success and a negative error code on failure.
> + * This function returns the scaned information on success and a negative error

                                scanned

> + * code on failure.
>   */
>  struct ubifs_scan_leb *ubifs_start_scan(const struct ubifs_info *c, int lnum,
>  					int offs, void *sbuf)


-- 
~Randy
