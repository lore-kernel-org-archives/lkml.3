Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3LMPPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:15:09 -0500
Received: from gloria.sntech.de ([95.129.55.99]:39703 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab3LMPPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:15:05 -0500
From: Heiko =?iso-8859-15?q?St=FCbner?= <heiko@sntech.de>
To: panchaxari <panchaxari.prasannamurthy@linaro.org>
Subject: Re: [PATCH CFT] ARM:S3C24XX: Enable ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR by default
Date: Fri, 13 Dec 2013 16:14:49 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1386934105-23392-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
In-Reply-To: <1386934105-23392-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312131614.50060.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 13. Dezember 2013, 12:28:25 schrieb panchaxari:
> Configs ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR are enabled as default
> to platform S3C24XX.
> 
> Introduction of PHYS_VIRT config as default would enable phy-to-virt and
> virt-to-phy translation function at boot and module loading time
> and enforce dynamic reallocation of memory. AUTO_ZRELADDR config would
> enable calculation of kernel load address at run time.
> 
> PHYS_VIRT config is mutually exclusive to XIP_KERNEL, XIP_KERNEL is used in
> systems with NOR flash devices, and ZRELADDR config is mutually exclusive
> to ZBOOT_ROM.
> 
> CFT::Call For Testing
> 
> Requesting maintainers of S3C24XX  platforms to evaluate the changes on the
> board and comment, as I dont have the board for testing and also requesting
> an ACK the changes.
> 
> Signed-off-by: panchaxari <panchaxari.prasannamurthy@linaro.org>
> Cc: Heiko Stuebner <heiko@sntech.de>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

apart from the possible issue Vasily pointed out, my current kernels for 
s3c2442 and s3c2416 seem to work flawlessly with AUTO_ZRELADDR and 
ARM_PATCH_PHYS_VIRT.

I just checked the configs and it seems these options get automatically 
selected and must be specially deselected by the user.


Heiko
