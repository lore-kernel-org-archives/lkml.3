Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbaIEIUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:20:41 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:56030 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbaIEIUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:20:38 -0400
MIME-Version: 1.0
In-Reply-To: <1409484115-1974-2-git-send-email-pramod.gurav@smartplayin.com>
References: <1409484115-1974-1-git-send-email-pramod.gurav@smartplayin.com>
	<1409484115-1974-2-git-send-email-pramod.gurav@smartplayin.com>
Date: Fri, 5 Sep 2014 10:20:38 +0200
Message-ID: <CACRpkdZ3MEDt3BS2OV73KkbaoB8Z0bE4Po2OWE9FB_d8OE8T2w@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: at91: Switch to using managed clk_get
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 1:21 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This patch switches to using managed version of clk_get and hence
> removes clk_put from failure path.
>
> CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Not much that can go wrong.

Patch applied.

Yours,
Linus Walleij
