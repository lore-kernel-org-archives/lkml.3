Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab3FTGxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 02:53:05 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33824 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab3FTGxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 02:53:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Victor <linux@maxim.org.za>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1370617863-18410-1-git-send-email-b.brezillon@overkiz.com>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Russell King <linux@arm.linux.org.uk>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
 <1370617863-18410-1-git-send-email-b.brezillon@overkiz.com>
Message-ID: <20130620065258.9136.63631@quantum>
User-Agent: alot/0.3.4
Subject: Re: [RFC PATCH 13/50] ARM: at91: move at91rm9200 SoC to new at91 clk implem
Date: Wed, 19 Jun 2013 23:52:58 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Boris BREZILLON (2013-06-07 08:11:03)
> +static struct clk_lookup pioA_clk_lookup[] = {
> +       CLKDEV_INIT(NULL, "pioA_clk", NULL),
> +       CLKDEV_INIT(NULL, "pioA", NULL),
> +};

It would be great to get rid of this clkdev data from the kernel as
well. Have you looked into encoding the aliases into your DT bindings?

Or have you looked into using of_clk_get?

Regards,
Mike
