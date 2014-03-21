Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761138AbaCUQxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:53:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:62561 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761052AbaCUQwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:52:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 6/7] DMA: sun6i: Add driver for the Allwinner A31 DMA controller
Date: Fri, 21 Mar 2014 17:51:56 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, devicetree@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, andriy.shevchenko@intel.com,
        linux-kernel@vger.kernel.org, zhuzhenhua@allwinnertech.com,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        dmaengine@vger.kernel.org
References: <1394723659-4995-1-git-send-email-maxime.ripard@free-electrons.com> <1394723659-4995-7-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1394723659-4995-7-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403211751.57114.arnd@arndb.de>
X-Provags-ID: V02:K0:3OHKO7kVl0rla1gdqZj0TAVrny5Vy8alieeYOr6Btdv
 UM+Mkd0W4UhFX3zjVaRMXwmD6yn2Eyy05GuflvCGO178Aa0Hv9
 s2QKo0PprttOhAJQSWXXgvqriyaluEvLV2Wy6HGsatf8qGiO4o
 2y0Wil7GkCcSWfknDh6lUGbKVnFxdsSiRVgfHMcWIN+gF868VO
 1ilnn+3nGLXXkwHsgcmE6TR7LPTkfOV1jyBFKXXW3Njw4vpdcb
 y+yZHN3gWYqoYm9aAslbfvJjeDEaiBFXoFcWuX6LFRElOpigEI
 BWPBmi59H7icHydzV4SCrGw7Onz2zUY0kcp0Bdy86kw/7zrz+A
 c0A/VrPwwtvtDItzut+nVc766amoSD/E5wuhf0vOW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2014, Maxime Ripard wrote:
> The Allwinner A31 has a 16 channels DMA controller that it shares with the
> newer A23. Although sharing some similarities with the DMA controller of the
> older Allwinner SoCs, it's significantly different, I don't expect it to be
> possible to share the driver for these two.
> 
> The A31 Controller is able to memory-to-memory or memory-to-device transfers on
> the 16 channels in parallel.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Looks good to me now,

Acked-by: Arnd Bergmann <arnd@arndb.de>
