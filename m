Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935134Ab3DHQUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:20:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60826 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934627Ab3DHQU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:20:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 4/5] dmaengine: ste_dma40: Only configure a channel during a configure request
Date: Mon, 8 Apr 2013 18:19:46 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>
References: <1365434591-21569-1-git-send-email-lee.jones@linaro.org> <1365434591-21569-4-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1365434591-21569-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304081819.46377.arnd@arndb.de>
X-Provags-ID: V02:K0:CpPaXZ3Q3A0NGkKQwEmqRBEV/jWKOIofukxY5z+Umrm
 /LRwX+l7bDnMqjtD84RJY5gG53K/+CDA5Ke+w1b0RMaZcFMTfJ
 SdVbxBt7anHvok1NwCm0b7X+BqDL565hLaPjcM0ZlMLM/IgVFs
 7nx8eso2Q0Wf1ZrHugSwhzCvPQhe/AoysFFejmfKaz+L2Y4HMi
 8XGT1d6Yi43cUJKxIH5SUpqqzT9m9RIqgFLEw9XV8nnARrRPmq
 SCbnC2Yn/fxbDvYtnB/V/VRw2K+WVuDCMQ2jBi7/IYkJXP+PDP
 zwoBT3rJ7IfzvuewxYf71U+NybpEc21Pi1vrO7o+KS0UaoUFBb
 iYW89/k31j2JA6ZBpYdw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 April 2013, Lee Jones wrote:
> According to the DMA documentation allocating a channel and configuring
> it are two separate actions. By moving the configuration code into the
> correct code path we lighten the burden on the information required to
> successfully allocate a channel.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I think the patch doesn't match the description. You only remove
the calls to configure the channel but don't add it in a proper
place.

	Arnd
