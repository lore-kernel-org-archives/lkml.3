Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084Ab3LJT2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:28:05 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:59812 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3LJT2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:28:03 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: dt for 3.14 #1
References: <1386602585-1927-1-git-send-email-nicolas.ferre@atmel.com>
Date: Tue, 10 Dec 2013 11:27:59 -0800
In-Reply-To: <1386602585-1927-1-git-send-email-nicolas.ferre@atmel.com>
	(Nicolas Ferre's message of "Mon, 9 Dec 2013 16:23:05 +0100")
Message-ID: <87txeg7bgg.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre <nicolas.ferre@atmel.com> writes:

> Arnd, Olof, Kevin,
>
> First pull-request focusing on DT material for AT91 on 3.14. This one is also
> based on the "cleanup" material already in arm-soc tree (at91/sama5-ccf) like
> all other AT91 pull-requests for 3.14.
>
> Thanks, best regards,
>
> The following changes since commit b46e837d8ef1f3c777bbf9513e2cdb5d87d6c374:
>
>   ARM: at91/dt: remove old clk material (2013-12-02 15:31:29 +0100)
>
> are available in the git repository at:
>
>   git://github.com/at91linux/linux-at91.git tags/at91-dt
>
> for you to fetch changes up to ca594844e4a53f778811c06feef60bdf36bc5fec:
>
>   ARM: at91/at91rm9200ek.dts: rearrange nodes in address ascending order (2013-12-09 15:08:57 +0100)
>
> ----------------------------------------------------------------
> First DT pull-request for 3.14
> - many little corrections and documentation updates
> - LCD FB Device Tree for at91sam9263 and at91sam9g45 boards
> - crypto peripherals DT entries + DMA specification
> - new Cosino board
>
> ----------------------------------------------------------------

Pulled into next/dt.

Thanks,

Kevin
