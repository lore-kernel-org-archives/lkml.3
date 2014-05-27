Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaE0OGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:06:49 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:33722 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaE0OGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:06:44 -0400
MIME-Version: 1.0
In-Reply-To: <1401117687-28911-19-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
	<1401117687-28911-19-git-send-email-benoit.taine@lip6.fr>
Date: Tue, 27 May 2014 16:06:43 +0200
Message-ID: <CACRpkdaz+cz5WW6udV7eQw+=c+mrzicp9rf5ab-P_E-iJ=ezYw@mail.gmail.com>
Subject: Re: [PATCH 18/18] pinctrl: pinconf-generic: Use kmemdup instead of
 kmalloc + memcpy
From: Linus Walleij <linus.walleij@linaro.org>
To: Benoit Taine <benoit.taine@lip6.fr>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 5:21 PM, Benoit Taine <benoit.taine@lip6.fr> wrote:

> This issue was reported by coccicheck using the semantic patch
> at scripts/coccinelle/api/memdup.cocci
>
> Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
> ---
> Not compile tested, due incompatible architecture.

Excellent fix, thanks. Patch applied.

Yours,
Linus Walleij
