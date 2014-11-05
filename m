Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaKECgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 21:36:06 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:39266 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaKECgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 21:36:04 -0500
MIME-Version: 1.0
In-Reply-To: <1415152615-20394-1-git-send-email-standby24x7@gmail.com>
References: <1415152615-20394-1-git-send-email-standby24x7@gmail.com>
Date: Tue, 4 Nov 2014 18:36:03 -0800
Message-ID: <CAADnVQLye-wFpnRgnSd6n=9awSA3Q_HshaMkZ=rdQ1C-zEtpFA@mail.gmail.com>
Subject: Re: [PATCH] [trivial] treewide: Fix typo in printk and Kconfig
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: trivial@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 5:56 PM, Masanari Iida <standby24x7@gmail.com> wrote:
> This patch fix spelling typo in printk and Kconfig within
> various part of kernel sources.
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> @@ -1103,7 +1103,7 @@ static int __init edac_devinit(void)
>                 dev = platform_device_register_simple("octeon_lmc_edac",
>                                                       i, NULL, 0);
>                 if (IS_ERR(dev)) {
> -                       pr_err("Registation of octeon_lmc_edac %d failed!\n", i);
> +                       pr_err("Regisrtation of octeon_lmc_edac %d failed!\n", i);

spell checking of your own patches would help too...
