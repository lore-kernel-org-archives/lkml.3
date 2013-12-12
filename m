Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab3LLSiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:38:52 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:48776 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab3LLSif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:38:35 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Olof Johansson <olof@lixom.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91: remove AT91_PROGRAMMABLE_CLOCKS configuration option
References: <52A9C81B.7050007@atmel.com>
	<1386864045-25198-1-git-send-email-nicolas.ferre@atmel.com>
Date: Thu, 12 Dec 2013 10:38:31 -0800
In-Reply-To: <1386864045-25198-1-git-send-email-nicolas.ferre@atmel.com>
	(Nicolas Ferre's message of "Thu, 12 Dec 2013 17:00:45 +0100")
Message-ID: <87sitx6hjs.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre <nicolas.ferre@atmel.com> writes:

> This AT91 specific Kconfig option removed the code that dealt with
> programmable clocks. Each AT91 SoC embeds programmable clocks and
> there is little gain to remove this code in case that such a clock
> is not used.
> If this option is not selected, it causes certain drivers to fail
> to build. We simply remove this option instead of adding code just
> to build a workaround.
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Olof, Kevin,
>
> This patch goes on top of the AT91 "cleanup" branch.
>

Applied to next/cleanup.

Thanks,

Kevin
