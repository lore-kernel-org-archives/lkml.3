Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3LPNXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:23:39 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:51963 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab3LPNXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:23:38 -0500
MIME-Version: 1.0
In-Reply-To: <1387132252-2584-3-git-send-email-b.brezillon@overkiz.com>
References: <1387132252-2584-1-git-send-email-b.brezillon@overkiz.com>
	<1387132252-2584-3-git-send-email-b.brezillon@overkiz.com>
Date: Mon, 16 Dec 2013 14:23:37 +0100
Message-ID: <CACRpkdbzPqWFsr1bCfgd9YpmyJ-04W8Yu5R_T-M6vOczT0y57Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: at91: replace clk_prepare + clk_enable by clk_prepare_enable
From: Linus Walleij <linus.walleij@linaro.org>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 7:30 PM, Boris BREZILLON
<b.brezillon@overkiz.com> wrote:

> Replace the clk_prepare and clk_enable calls by a single
> clk_prepare_enable call.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Patch applied with Nicolas' ACK.

Yours,
Linus Walleij
