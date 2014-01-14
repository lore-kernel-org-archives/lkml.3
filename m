Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaANSem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:34:42 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:54367 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaANSek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:34:40 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        ARM Maintainers <arm@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91: smc: bug fix in sam9_smc_cs_read()
References: <1389279714-30873-1-git-send-email-nicolas.ferre@atmel.com>
Date: Tue, 14 Jan 2014 10:34:38 -0800
In-Reply-To: <1389279714-30873-1-git-send-email-nicolas.ferre@atmel.com>
	(Nicolas Ferre's message of "Thu, 9 Jan 2014 16:01:54 +0100")
Message-ID: <87fvoq8la9.fsf@linaro.org>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre <nicolas.ferre@atmel.com> writes:

> From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>
> There was a copy/paste error when reading the nwe_pulse value.
>
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> Acked-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Cc: stable <stable@vger.kernel.org> # 3.3
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Arnd, Olof, Kevin,
>
> This is a little fix that I have just received. As the "fixes" colletion is
> certainly closed for 3.13, I would like to include this one in the
> "fixes-non-critical" topic for 3.14.
>
> For the time being, I only have this one, so It can be convenient if you take
> this fix as a patch instead of a pull-request.

Applied to fixes-non-critical, and merged into for-next.

Thanks,

Kevin
