Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833Ab3DKMIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:08:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57639 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab3DKMIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:08:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 12/30] video/exynos: remove unnecessary header inclusions
Date: Thu, 11 Apr 2013 14:08:11 +0200
Message-ID: <3895822.NrzbfBoRSl@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-17-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <5166A3DB.6060700@ti.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de> <1365638712-1028578-13-git-send-email-arnd@arndb.de> <5166A3DB.6060700@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5cgGhwOlBGdUqLAOwBpkt9f42cUbx1q5eWVRFsJkUl0
 6mRrL8d8cctks39DxOfwptOV1O98g26qryJlv10PK8S+s1waLe
 7968uGpB3AmOLVU0TQa7EwK1/Hw59I+7Kp5XQ7FJ6ve1qiKMSp
 UXFVBThuiJ3qDwKWPfCzcBgrHASE+kuo6VBcgYqCT5Z6YwXYYW
 NLBrvJziPUDUST9SBdJeob1pbGRwnIQBS5kcgEkWWmBcrt1UbE
 BkfrvWRdb9QrnzCMsM0k86QBur2jPLZy9JajPItlRf++j9gu/w
 9KuBDTRF9yfErxhouoc4DvvF7HbvtGk5SFHIUgQ5E+roJViJSK
 7oXDpSQtazFTh4i/13HI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 April 2013 14:51:55 Tomi Valkeinen wrote:

> I've applied this and the next patch ([PATCH 13/30] video/s3c: move
> platform_data out of arch/arm) to fbdev.
> 
> I also fixed the extra space mentioned by Jingoo.

Thanks!

	Arnd
