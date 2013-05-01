Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab3EAK15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 06:27:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54911 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758915Ab3EAK1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 06:27:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 5/5 v2] dmaengine: ste_dma40: Fetch disabled channels from DT
Date: Wed, 1 May 2013 12:27:06 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
References: <1367336497-10650-1-git-send-email-lee.jones@linaro.org> <1367336497-10650-5-git-send-email-lee.jones@linaro.org> <20130501095406.GE25256@gmail.com>
In-Reply-To: <20130501095406.GE25256@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305011227.07086.arnd@arndb.de>
X-Provags-ID: V02:K0:JY6OedBrDA7eKt7mP8qz643V5A8iiKtX8xPeU/lwWhT
 7q1cV6F+rKgdRZ5M0kPizbXkMKmu3VeCOCNNFnWhj+Ve7DrNQ+
 P0eTE8ZtNGuB304MbGdzuo7oqZAufGA+OqZviM24znBldnoAjp
 Xakd7w4n0KU3sdeR6X/4U82OPQ8ue7RVHxWDCwtdkF/Mbc9Kv6
 MSqFDgyHKlkyUsMe91fVEIj6Uh3qvVU+lWVZO+YzJsnNBmXuqF
 05riv25jLzhJWEHP/V4epNzpCGIF83WPydn2ErkXGqwEdAsTi2
 Uh30deO9INLYxE4wHSBLF7wwj5R8zY8UunfqYpNels9mfWxMuJ
 /yTLRyBk0Xo6AHfg5LA0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 May 2013, Lee Jones wrote:
>     Some platforms have channels which are not available for normal use.
>     This information is currently passed though platform data in internal
>     BSP kernels. Once those platforms land, they'll need to configure them
>     appropriately, so we may as well add the infrastructure.
>     
>     Cc: Vinod Koul <vinod.koul@intel.com>
>     Cc: Dan Williams <djbw@fb.com>
>     Cc: Per Forlin <per.forlin@stericsson.com>
>     Cc: Rabin Vincent <rabin@rab.in>
>     Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
