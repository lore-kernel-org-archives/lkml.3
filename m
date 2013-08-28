Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab3H1MSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:18:09 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:39229 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3H1MSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:18:08 -0400
MIME-Version: 1.0
In-Reply-To: <1377578476-3268-4-git-send-email-jszhang@marvell.com>
References: <1377578476-3268-1-git-send-email-jszhang@marvell.com>
	<1377578476-3268-4-git-send-email-jszhang@marvell.com>
Date: Wed, 28 Aug 2013 14:18:07 +0200
Message-ID: <CACRpkdZ_RJpqm-TzuEt7_g7kaPhQJ3PZPK1kYxp3UkSZNSbX-w@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] pinctrl: mvebu: Convert to use devm_ioremap_resource
From: Linus Walleij <linus.walleij@linaro.org>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 6:41 AM, Jisheng Zhang <jszhang@marvell.com> wrote:

> The resource mapped by of_iomap() isn't unmapped in error path. This
> patch fix the resource leakage by using devm_ioremap_resource() instead
> of of_iomap().
>
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Acked-by: Jason Cooper <jason@lakedaemon.net>

Patch applied.

Yours,
Linus Walleij
