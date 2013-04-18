Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968287Ab3DRKxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:53:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51292 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967253Ab3DRKxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:53:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 14/32] dmaengine: ste_dma40: Remove 'always true' checking
Date: Thu, 18 Apr 2013 12:53:33 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <1366279934-30761-15-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366279934-30761-15-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181253.33762.arnd@arndb.de>
X-Provags-ID: V02:K0:++lBT8XvfNuS9+H9jPMWfrIA+IcKmwdWzyf2CdbJjoq
 ou21mI2M6yoGNBLwHuyPSVm34ZWdaSMqeUZpMZXYK/csttZHq3
 R0Fzd5hVv0KkHo2efPOQ8YhfxomEtCZfwYvS9BMEjA7hiQvyug
 jpY4+EZfg7dzU3r5fC6rQPZHKyGvPrH/5V/eA67uupZ7exQ+Cw
 QNiEXjH0y7LTIYOPEEW4KAV7kSFC0GBd/TOEMeqaaEtLlyvfUi
 umNeGpMdRJGhLkEYyq1aQh7Ap0QX6OJnquJTiwVbp8MXM6LUq7
 DxyNsBF2WnR65Kam56ZaLMVxZeScItrtnzTNt5Mzk9y77nFUEW
 EHz3iADhIOFEel9AFDO8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Lee Jones wrote:
> Before allocating memory for logical channels, the current driver
> checks to see if there are any. Well as the dma40_memcpy_channels[]
> array is always populated, the check is always true. Best to
> remove the check.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
