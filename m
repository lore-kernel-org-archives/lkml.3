Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935234Ab3FSVw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:52:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61907 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934566Ab3FSVwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:52:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] dmaengine: PL08x: Avoid collisions with get_signal() macro
Date: Wed, 19 Jun 2013 23:52:16 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1371670708-26161-1-git-send-email-broonie@linaro.org>
In-Reply-To: <1371670708-26161-1-git-send-email-broonie@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306192352.17093.arnd@arndb.de>
X-Provags-ID: V02:K0:mnVw0WmiE1ECAp4KBv64jgsZs4cKR4Ckt81nDkv5mE5
 +iWXS+2UzF/AifLpUZvnfOe3miHHP8M9VjvMtkTGoKxMYKnVV0
 0dKvyxaUubS4lEb9tkJQ1OLUVk0mZLuK2IGSCw9Jlnv5GUDTt1
 8ggpwQSIzyvBz/rvsG0/kkvW4WUOY70f/Yn0D1TXy/W/lCl7hg
 a1/9Wf6M/ybkTvKDgVsB6iFIBsqMq1zj1C8ZJbplBzFhXZt2Oz
 Xqc0k5VS5anxe/iXIeKDEj6omSzNYqzU2xwuCqmepeZJ2R9Rwm
 zGFMW88OGt0RyVTLQdYF5ggtjlZ45BckKWy4TApkMXd7yuDuTo
 evDOGz8k5a0cRuV3y5E4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 June 2013, Mark Brown wrote:
> As pointed out by Arnd Bergmann there is a get_signal macro definied in
> linux/signal.h which can conflict with the platform data callback
> function of the same name leading to confusing errors from the compiler
> (especially if signal.h manages to get pulled into the driver itself due
> to header dependencies).  Avoid such errors by renaming get_signal and
> put_signal in the platform data to get_xfer_signal and put_xfer_signal.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
