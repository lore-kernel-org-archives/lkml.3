Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab3HPPRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:17:23 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:46371 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab3HPPRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:17:22 -0400
MIME-Version: 1.0
In-Reply-To: <1376471493-22215-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
	<1376471493-22215-4-git-send-email-Julia.Lawall@lip6.fr>
Date: Fri, 16 Aug 2013 17:17:21 +0200
Message-ID: <CACRpkdYuV9UG8XBu6Ti5Ef+M-SrwKi02jAEuH=zbqG9q+3oRcQ@mail.gmail.com>
Subject: Re: [PATCH 3/29] drivers/gpio: simplify use of devm_ioremap_resource
From: Linus Walleij <linus.walleij@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 11:11 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Remove unneeded error handling on the result of a call to
> platform_get_resource when the value is passed to devm_ioremap_resource.
>
> Move the call to platform_get_resource adjacent to the call to
> devm_ioremap_resource to make the connection between them more clear.

Patch applied with Viresh's ACK.

Yours,
Linus Walleij
