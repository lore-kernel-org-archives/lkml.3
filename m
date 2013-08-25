Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3HYDSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 23:18:22 -0400
Received: from void.printf.net ([89.145.121.20]:41120 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab3HYDSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 23:18:20 -0400
From: Chris Ball <cjb@laptop.org>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH v4 2/5] mmc: atmel-mci: prepare clk before calling enable
References: <1374132753-15206-1-git-send-email-b.brezillon@overkiz.com>
	<1374133132-17556-1-git-send-email-b.brezillon@overkiz.com>
Date: Sat, 24 Aug 2013 23:18:14 -0400
In-Reply-To: <1374133132-17556-1-git-send-email-b.brezillon@overkiz.com>
	(Boris BREZILLON's message of "Thu, 18 Jul 2013 09:38:52 +0200")
Message-ID: <87li3qsbk9.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 18 2013, Boris BREZILLON wrote:
> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
> avoid common clk framework warnings.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>

Okay, pushed to mmc-next for 3.12.

Boris, you got feedback from Thomas Petazzoni and Russell King, but
you didn't CC either of them on the patch v4, and you didn't write a
changelog explaining the differences between patches v3 and v4 --
please do both of those next time.

Also, it looks like the Ack from Ludovic happened away from the MMC
list, since I don't see a message from Ludovic on the thread here.
It would be better if the Ack happened somewhere I can see it.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
