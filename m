Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaEWUJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 16:09:16 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:49155 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaEWUJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 16:09:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Anders Berg <anders.berg@avagotech.com>
Subject: Re: [PATCH v4 0/5] Add platform support for LSI AXM55xx
Date: Fri, 23 May 2014 22:08:56 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1400834521.git.anders.berg@avagotech.com>
In-Reply-To: <cover.1400834521.git.anders.berg@avagotech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201405232208.56676.arnd@arndb.de>
X-Provags-ID: V02:K0:MZUH/WSqdaQrBcu7obA5Iwxn3MIZc+z1tAX13BwR73Y
 hUWhYqkmyoWlmQeF/Jv6lbNWEkaufWFrbrsm85U3fxVkYtIzSE
 vJi/Um2M3IYgkc4TPo32IrVntJzU/f4Bjjrmpo7rH8pypB6eRg
 QpRcwUglI09hItIF+6/9hUFzU//5O85b/iKx4xRSUvrgy50BbL
 7uptdkfREbfkVk+qUijEIt4HlaxZBGY17HhXY6upxDU2/7OvYT
 /iD7chC5eHpfLodGXIk/DePyUkoc5VfmQlEWW02NyOqhr1bCyk
 FPFGIAw0ctJ+kQT7pDyxgKcMaArKDpShWxtp5nxN+63PrZh9pX
 xrsaKlFBxXLEBrfceRbo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2014, Anders Berg wrote:
> Hi,
> 
> Here is version 4 of platform support for AXM5516 SoC.
> 
> The clk driver is now applied to clk-next. The rest should be ready for
> arm-soc. Haven't got any response from the power/reset maintainers... I hope
> this driver can be taken via arm-soc as well.

I've merged it all into the next/soc branch now, thanks!

In the future when submitting patches for inclusion, please add the arm@kernel.org
alias to Cc to ensure we don't miss it.

	ARnd
