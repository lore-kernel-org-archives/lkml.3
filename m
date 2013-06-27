Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab3F0NG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:06:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52317 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab3F0NGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:06:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: non critical fixes (for early 3.11) #2
Date: Thu, 27 Jun 2013 15:03:43 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, daniel.lezcano@linaro.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
References: <1372254307-2063-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1372254307-2063-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306271503.43864.arnd@arndb.de>
X-Provags-ID: V02:K0:YqRIG161nptMEVIfKmk2BFXQ5GT7XzLYvNWMpybtdp6
 BJ4JNwNAazTBf7w2Kd8YGpGdk/xqlm64RaWg8lmIQZhFfTZ6ng
 Tit0IS/lfwnsS0ej/hZ6JWZIJU9nbkJRoyLV2JiOTLqGVxVcDE
 isQEzhNcbCcApHBn83qf+lc5rNBcRYdc8JhszHhSkxFvUHWC8u
 HwEcN5aze3anWPeyhKdGq14mrJtUfLDb/9tQBLM+XRnqzNo3LI
 +XFjxbAfR0if68K1Nto2MTEP1hFP8qY6/9WoTmw1axOCoWW/z7
 PxzJa5O3MsHfQQdFvwsw+DacGrGwWYDrvXZEHLfwshvTS5JvTk
 VjPtkMqJ8hLk3ne0pqVU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 June 2013, Nicolas Ferre wrote:
> Another fixes-non-critical pull-request for early 3.11. It is of course based
> on the patches that you already have in arm-soc/at91/fixes.
> 
> Thanks, best regards,
> 
> The following changes since commit 133e00116b5bc76110bcc41ded369489209b641f:
> 
>   ARM: at91: Change the internal SRAM memory type MT_MEMORY_NONCACHED (2013-06-18 10:20:30 +0200)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-fixes
> 
> for you to fetch changes up to bd2da9ca138e446824a7542b381aed442fef4caa:
> 
>   ARM: at91/PMC: use at91_usb_rate() for UTMI PLL (2013-06-26 15:24:11 +0200)

All of these look simple enough, so I've pulled them into next/fixes-non-critical.

Thanks,

	Arnd
