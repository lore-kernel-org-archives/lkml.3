Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab3DNRBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 13:01:42 -0400
Received: from gloria.sntech.de ([95.129.55.99]:33458 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab3DNRBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 13:01:40 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 08/30] i2c: s3c2410: make header file local
Date: Sun, 14 Apr 2013 19:01:31 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de> <1365638712-1028578-9-git-send-email-arnd@arndb.de> <20130414122035.GB9013@the-dreams.de>
In-Reply-To: <20130414122035.GB9013@the-dreams.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304141901.32286.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 14. April 2013, 14:20:35 schrieb Wolfram Sang:
> On Thu, Apr 11, 2013 at 02:04:50AM +0200, Arnd Bergmann wrote:
> > No other file in the kernel besides i2c-s3c2410.c uses the current
> > plat/regs-iic.h, so we can simply move the header file to live in the
> > same directory as the driver, as a preparation to multiplatform builds.
> 
> What about putting the regs in the driver itself?

they already are :-) [0] and Arnd will drop this patch in his next iteration 
[1].


Heiko


[0] 
https://git.kernel.org/cgit/linux/kernel/git/wsa/linux.git/commit/?h=i2c/for-
next&id=e636602ac2613da8c1777cb42443223994be4107

[1] Message-Id: <201304121011.13028.arnd@arndb.de>
