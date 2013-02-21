Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3BUQSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 11:18:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60671 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab3BUQSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:18:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shiyan <shc_work@mail.ru>
Subject: Re: [PATCH v4] mfd: syscon: Add non-DT suppor
Date: Thu, 21 Feb 2013 16:18:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1361460542-2872-1-git-send-email-shc_work@mail.ru>
In-Reply-To: <1361460542-2872-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302211618.12558.arnd@arndb.de>
X-Provags-ID: V02:K0:eOjIzIyJZJXijkyJjSQ89/NhKdxmx2W6/9TedjrNziA
 V44ES6BGXNJF7FF9Or/XqW6Gd1EKqKFtr0i52UrHPMK1SAk44R
 2daqFZ3PttJCPNlRXd9gCko0UBe6yXhyvAo39VIusL3jjMVM4l
 NPcQc5nljZNjA3K5y0gMfVe7Ibf8iRGzokjrRyVKCccmxmB4Su
 1o1KHW0OvRveCDZ2ccuij/SWGxW/FFUsUBWvZHRhAeTBcL9p2c
 rJ2sCE944T4TVS6sOLiPeQuKPyiuoebe9ee0AsVtaOtswQF+oC
 BqGo1RkQcVdHG2HvyvKivUClmm69jxsDMW70z4ovX3ByCFgdbi
 c/3/892DtcCXGAIWnWIQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 February 2013, Alexander Shiyan wrote:
> This patch allow using syscon driver from the platform data, i.e.
> possibility using driver on systems without oftree support.
> For search syscon device from the client drivers,
> "syscon_regmap_lookup_by_pdevname" function was added.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>

Looks good to me now.


Acked-by: Arnd Bergmann <arnd@arndb.de>
