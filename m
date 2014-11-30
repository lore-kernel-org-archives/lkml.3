Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaK3OzJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 09:55:09 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:54034 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaK3OzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 09:55:08 -0500
MIME-Version: 1.0
In-Reply-To: <1417349988-9238-3-git-send-email-richard@nod.at>
References: <1417349988-9238-1-git-send-email-richard@nod.at>
	<1417349988-9238-3-git-send-email-richard@nod.at>
Date: Sun, 30 Nov 2014 12:55:06 -0200
Message-ID: <CAOMZO5BVewD==3dDLBD_AwrffMBih5EG3YYfYBAfH=+wDpV=3Q@mail.gmail.com>
Subject: Re: [PATCH 2/6] UBI: Add accessor functions for WL data structures
From: Fabio Estevam <festevam@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2014 at 10:19 AM, Richard Weinberger <richard@nod.at> wrote:

> +/*
> + * ubi_for_each_free_peb - walk the UBI free RB tree.
> + * @ubi: UBI device description object
> + * @e: a pointer to a ubi_wl_entry to use as cursor
> + * @pos: a pointer to RB-tree entry type to use as a loop counter

tmp_rb instead?

> + */
> +#define ubi_for_each_free_peb(ubi, e, tmp_rb)  \
> +       ubi_rb_for_each_entry((tmp_rb), (e), &(ubi)->free, u.rb)
> +
> +/*
> + * ubi_for_each_used_peb - walk the UBI used RB tree.
> + * @ubi: UBI device description object
> + * @e: a pointer to a ubi_wl_entry to use as cursor
> + * @pos: a pointer to RB-tree entry type to use as a loop counter
> + */

tmp_rb instead?

> +#define ubi_for_each_used_peb(ubi, e, tmp_rb)  \
