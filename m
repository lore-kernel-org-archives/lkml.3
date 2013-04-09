Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935658Ab3DIS4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:56:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55740 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761262Ab3DIS4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:56:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 6/8] dmaengine: ste_dma40: Move LCPA allocation and real-time config
Date: Tue, 9 Apr 2013 20:56:30 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org> <1365532783-27425-6-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1365532783-27425-6-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304092056.31101.arnd@arndb.de>
X-Provags-ID: V02:K0:u8qEn2Ft6HJpzwEUQIgSYmMnmB6UExbDuPxzk3LEcEB
 wSMQt+YPRrmQLfptLObn3Bzon7cvXNeuBK5TCirM/QcsrANALL
 NPxrfZImGCwS20fZ7GgHGizSIlvUD8W2xzokblq7UoWcXLdGON
 p7a/RazjO8h6XWqNo/Qm9u1g7kYy7L7BxfYWCS10MSNqgzeDbm
 htnAWG6dA5FU7PEYGe0Au/eT9UOFj/w9wfNH03TkbBa72IulAY
 Scxq93Zs0uYo12j2PJYqd113D8lrQQma3qakOXEs/LHR9vct+t
 YyPRJx2dSdUKokGHDy8SmPKJ8P5WJ0xNRVK75ER4TqYLG8HwCe
 oJ96ysHRYV5H3OHCyKog=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Lee Jones wrote:
> There are various pieces of configuration which do not need to happen
> until after a channel is allocated. Here we move some of these so they're
> dealt with when it's time to configure the channel, rather than allocate
> it.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
