Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaEWQPC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:15:02 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:51153 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaEWQPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:15:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.15 #2
Date: Fri, 23 May 2014 18:14:47 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
References: <1400780084-12085-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1400780084-12085-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201405231814.47539.arnd@arndb.de>
X-Provags-ID: V02:K0:4GqKyvuIc2OHBpP78dfbIO1wTs0IT6kh35yY/QI88q1
 1/ZHky0lOi5jEVvLbHIXe+ZudY0gVJ/VynfTNjdi+5Szx++o8C
 ICjJ2BYONp0bDRx/JXW+xAktsESoUa/DtpyivvCvNYMAYEN4Dc
 U/6umzqXaNLmiGaaZ+/JHeY/B3Tz7qDWLGCdNnsKiPjw2LU+W+
 e1AUw3rAOav9I9nF9OC1cj22lvG/M+d8YkfmdcOQ8PfeIVUmzJ
 nSRUiK0/As5usIZK7eELZL01Ds/QlUIf7jbhdOSzAZKObC9Zw7
 S9lr4eOoynSTRhEP5OpmkkyDWyXxCye+N16Mrn4iM2RYWhbGv/
 64BQhTPFUD9NHU8N4aEY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2014, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> Two more fixes for AT91 dealing with iio ADC triggers on
> at91sam9260/at91sam9g20. These fixes are not critical as the option is not
> widely used. But as they are pretty tiny, it might be interesting to include
> them now.
> 
> Thanks, best regards,
> 
> The following changes since commit 35d35aae817706800a4913711d563a99e1dc380a:
> 
>   dt-bindings: clock: Move at91.h to dt-bindigs/clock (2014-04-18 23:44:52 +0200)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-fixes2
> 
> for you to fetch changes up to 13984e9bb15528f70059bbbbda3f9028157eebf6:
> 
>   ARM: at91: sam9260: fix compilation issues (2014-05-22 18:39:34 +0200)
> 
> ----------------------------------------------------------------
> Second 3.15 fixes for AT91
> - two fixes concerning iio ADC triggers for at91sam9260 and at91sam9g20
>   one for the "device" file, the other for the DT.

Pulled into fixes branch, thanks!

	Arnd
