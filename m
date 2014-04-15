Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaDORG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:06:29 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:50576 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaDORG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:06:27 -0400
MIME-Version: 1.0
In-Reply-To: <1397581111-21148-1-git-send-email-nm@ti.com>
References: <534D61DF.9090203@ti.com>
	<1397581111-21148-1-git-send-email-nm@ti.com>
Date: Tue, 15 Apr 2014 19:06:25 +0200
Message-ID: <CAGhQ9Vxv682wD982sNDtc5-Zk4y7H2eULWcm8CJ2SiG=s7V=Pg@mail.gmail.com>
Subject: Re: [PATCH V2] crypto: omap-des - handle error of pm_runtime_get_sync
From: Joachim Eastwood <manabian@gmail.com>
To: Nishanth Menon <nm@ti.com>
Cc: Joel Fernandes <joelf@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org, balbi@ti.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 18:58, Nishanth Menon <nm@ti.com> wrote:
> pm_runtime_get_sync may not always succeed depending on SoC involved.
> So handle the error appropriately ensuring usage_count is accurate in
> case of failure.
>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> V2:
>         - review fixes, print function names in error log as well.
>
> V1: https://patchwork.kernel.org/patch/3993861/
>  drivers/crypto/omap-des.c |   26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
>

Fixes the runtime warning from omap_l3_noc when omap-des is built-in
on my VAR-SOM-OM44 (OMAP4460) board.

Tested-by: Joachim Eastwood <manabian@gmail.com>

regards
Joachim Eastwood
