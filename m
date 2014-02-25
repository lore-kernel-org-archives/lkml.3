Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaBYTLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:11:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.131]:64939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaBYTLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:11:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH resend] pwm: Remove obsolete HAVE_PWM Kconfig symbol
Date: Tue, 25 Feb 2014 20:11:01 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Eric Miao <eric.y.miao@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>, linux-pwm@vger.kernel.orig
References: <1390550056-5924-1-git-send-email-s.hauer@pengutronix.de> <20140210102017.GA20143@ulmo.nvidia.com>
In-Reply-To: <20140210102017.GA20143@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201402252011.01902.arnd@arndb.de>
X-Provags-ID: V02:K0:d60W9E5Xj+lgBtBntJFO4kwTB1OjColK4WLm0P6N6Ct
 WPIhJNzCcm8K1XbiHtSTuR+szr5VqBkbpTnFDfLrplOdTXxRdp
 tdJPCcjC1feZ40/BXoBGt4LC/SrggZRzQe7LUNIjRLHEAH+oqC
 E5kxTgxlrkZGbI03K6K0MoeWBNEpnaH8DeG7xWH5Xtx9CwaFP+
 GRR8pCHTyKoOIdILOYtBkNypHIS1cApCBd1nKGIh7HKd5m2YnS
 5xHU1UhBdJZ38PY3Z+tQCr/TWTlrQJc/xeGQgV5ne2zWHHtV+U
 cP3Xa5ra6QaENjf65WOg/eNVi/YY9YDPq7kqr1gs/NwxHwMtwr
 Gec84XIf5mZCKFJkjJ8Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 February 2014, Thierry Reding wrote:
> On Fri, Jan 24, 2014 at 08:54:16AM +0100, Sascha Hauer wrote:

> > Thierry as PWM maintainer has agreed to take this patch. Would be nice
> > to get some Acks from affected architectures. Russell, Ralf?
> 
> No replies for over two weeks and this looks simple enough, so I just
> went ahead and applied it. Thanks,

Am I looking in the wrong place, or have you not pushed this for linux-next yet?
I still see all the HAVE_PWM symbols in today's -next.

	Arnd
