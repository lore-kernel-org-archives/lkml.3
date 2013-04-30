Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757Ab3D3Onw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:43:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54967 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760050Ab3D3Onu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:43:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v3.10] mmc: sdhci-s3c: Fix operation on non-single image Samsung platforms
Date: Tue, 30 Apr 2013 16:43:43 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1367330907-13525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1367330907-13525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304301643.43989.arnd@arndb.de>
X-Provags-ID: V02:K0:eXQmIjaGjuT7xbD7U14k/Rw/644wiRm7CxjgGjwiyBZ
 yE3RdB/wRAcTtjDXkRBDjr4+SB5+LWotw690vCxFT2rlXcUIXh
 8+qX3OOpdtpSF79ab+E5PaC04U2SaNO2YJyqT2+BVRVapstN84
 TKh2I2+3qDukRvh+O1oHH5nU4WMVF1w27eGtio71v7FcmKIOOb
 fxYCbKelhiFdB6lbwbcdTSAkkBhxWpWmxnh1AeaK7Z1BswPXwh
 lev7D04lbnf4XQ+j0qEKMYoj7NApdR+V1Zv3fSz0/dCHi+7JNf
 2G+yLKFII5nWf0kn8245dMtaVCVaE9MZBqUELjZsSABiRGTRJV
 1JPiuNw/xliSVjBZ9s+Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 April 2013, Mark Brown wrote:
> Commit cc014f3 (mmc: sdhci-s3c: remove platform dependencies) changed
> the platform dependency in Kconfig to depend on SAMSUNG_SINGLE, meaning
> the driver was available only on single zImage Samsung platforms.  This
> breaks platforms that haven't been converted such as S3C64xx.  Revert
> that part of the change to fix.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Actually this part of my patch was just a mistake, and should never
have been in there. I'll apply your patch and amend the changelog.

Thanks a lot!

	Arnd
