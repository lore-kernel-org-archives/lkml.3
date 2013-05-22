Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab3EVOlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:41:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57016 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab3EVOlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:41:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] ARM: ux500: Apply other compatible name to the u8540 DTS file
Date: Wed, 22 May 2013 16:41:33 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
References: <1369233402-19225-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1369233402-19225-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305221641.33602.arnd@arndb.de>
X-Provags-ID: V02:K0:B/TzyfNY7WM8mntCHJmPf2ThloinSO9XNsj8rN+Y32P
 mVrLpN4+TVcsQ5yF37YMDRzGehr3Y+tOCFcHtaM0g4ofQ3w/sM
 B9SdFy3jh6C7JTtumU4zHeliEEfU08ss3QWdq7+isGV8rBMrpl
 cbTiviZwFp67XCjBAN8a109jibRjz4yFo7u9tj91No2MvBUJtn
 o+Mxrf+Jm/dMO2SLoq0N0+Wtrt6P0bgquamNRFw8DsMdbGcZig
 06TYO+QqE37PQzV4SVfBlDgWPJqpCQsuDPbbNuN8VB8lZDxrOI
 wvAVs03FFxCzWoT94Irz51CiwvO5gWygDAfIcys63UmLnPl1E7
 CMSKJY8M80KI1ME8keUs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 May 2013, Lee Jones wrote:
> The common name for the 8540 is the u8540, but the fully qualified
> name, or proper name is ccu8540. Ensure both are available to drivers
> and platform code that wish to use them.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I'm confused by this. I thought that u8540 is the chipset while ccu8540 is
the board. Is that wrong?

	Arnd
