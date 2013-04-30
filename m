Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab3D3UnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 16:43:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61403 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933307Ab3D3UnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 16:43:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 3/5] ARM: ux500: Stop passing DMA platform data though AUXDATA
Date: Tue, 30 Apr 2013 22:43:01 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
References: <1367336497-10650-1-git-send-email-lee.jones@linaro.org> <1367336497-10650-3-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1367336497-10650-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304302243.02145.arnd@arndb.de>
X-Provags-ID: V02:K0:kinIEDxixzt4cUzh7qZoNsoGmlVUwrL8QnVihvMBpyN
 9BpGUfI1XlbpXlEobzqALYnXhoeoaBLpRx/9WeLMaKbBN8jPbt
 /U3UEe1rHGJ3kr+lLplAuuN8ESzDea0KXK3K7Awa1M94vLV9u+
 j9ulMmqYuMDT1Y8/SJY6zBdZqRQuz5aZcV26ArRd06ZBPHRn0c
 gxa5hYjKfvMFSt432dToI4HR4CLUikLpAxdy1MwNbrjEFmDvBS
 aRQRJeI3DSm4g2YGO7CIyKtl2tfg+rt+zFz8LE0n4V85Gzh1m0
 3lwFn82Lrjpn0RXWZIYCWV8SK/1S8Nspuk2ocyUqJPW1HO7+LL
 WifDBh31qT/Y14HFfvCk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 April 2013, Lee Jones wrote:
> The DMA platform data is now empty due to some recent refactoring,
> so there is no longer a requirement to pass it though.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
