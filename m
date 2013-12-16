Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3LPNW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:22:26 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:51190 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab3LPNWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:22:24 -0500
MIME-Version: 1.0
In-Reply-To: <1387132252-2584-2-git-send-email-b.brezillon@overkiz.com>
References: <1387132252-2584-1-git-send-email-b.brezillon@overkiz.com>
	<1387132252-2584-2-git-send-email-b.brezillon@overkiz.com>
Date: Mon, 16 Dec 2013 14:22:24 +0100
Message-ID: <CACRpkda4NQ1VR=G+EgYcMY6HcanyMU+MC3CKAq8VWtLhfonrdQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: at91: fix clk_unprepare and clk_disable order
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

> clk_unprepare shall be called before clk_disable.
> Fix the issue by replacing the clk_unprepare and clk_disable calls by a
> single clk_disable_unprepare call.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Patch applied with Nicolas' ACK.

Yours,
Linus Walleij
