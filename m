Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935906Ab3DRK6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:58:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65040 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935341Ab3DRK6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:58:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 23/32] dmaengine: ste_dma40: Allow driver to be probe()able when DT is enabled
Date: Thu, 18 Apr 2013 12:58:04 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <1366279934-30761-24-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366279934-30761-24-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181258.04477.arnd@arndb.de>
X-Provags-ID: V02:K0:7QfENAwcd2T+4DiiblPF6BY1OHuAcmZ2pm/D1fO9ETc
 to827+GbADeojPmpeFJPlexLqJm8Mh/j3xAdK/pF3DN76mw7Lb
 35MTAAEvgZFKn1UACQ7cNKjlTq1WYIJrNDW+liBh1lBozWtwvt
 8KNif2TvCAypJTQFeME6vkKG8QO7D20YkAeiiO4H0Q81dn4YPH
 zWEFVfVDDOQv2uBhaQUYZ5CsZwn2Y7GLtpwEY1AECH5Abdezuu
 280BiVUyT0IimKQ6uzJmc3clSBuUmk6nbRYa2TSPGBjY5KvC+z
 Oj+OBTajyIlIk+7BIRBvf+fAbV4nSjqWiR7MCUYnLl6YSZVZiD
 TAVoK5OjcYE3jn22+4Tk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Lee Jones wrote:
> When booting using Device Tree, devices aren't registered in the normal
> way. Instead, they need to be provided with a compatible string which is
> held in an OF Match Table for comparison during start-up. Here we provide
> the compatible string and prepare the driver to not receive a platform
> data pointer.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
