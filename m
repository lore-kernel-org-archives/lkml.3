Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935832Ab3DIS7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:59:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63116 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935472Ab3DIS7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:59:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 3/8] dmaengine: ste_dma40: Actually write the runtime configuration to registers
Date: Tue, 9 Apr 2013 20:59:37 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org> <1365532783-27425-3-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1365532783-27425-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304092059.37739.arnd@arndb.de>
X-Provags-ID: V02:K0:t4K2mBRkaiXkq9S5tfYCwtQ7J6aCxZkYTEULyk4qB4M
 sg57iaOKP/Wyo6+fosdvXqnDm3C0LtcAI8NAw2iVT2C4hHnMoA
 k5IwPVD/EZ5m2GHQnGapKa2yAVf1z9YU9JyVBB9sV5kxfO1zam
 QrDjAPl4WNi1YvrtvvaESX9cX8lcpo91TU9zN2LUUCHZQjpWOs
 cS5ewQ3dkPCYIfaaQw8aKBSLBqwdB/czoW4b+stQN87Ht7Sy+Z
 Yq52h3Tz6mvu+66K/R99ryh7i8KOPRzhWOM827puhJmpDVD1iA
 Xkc66Ou7VA+VRl9ZUh1EtFW2BTIBq0yGB7ogutn6LFUoZG6M/n
 bMgwG9j7X2xjl88kqnJI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Lee Jones wrote:
> Someone has spent a fair amount of effort writing a runtime configuration
> changing algorithm for DMA clients. However, the config appears to never
> actually make it to hardware. In order for the configuration to take hold
> we need to issue a d40_config_write(), as this is the routine which writes
> it into the hardware's registers.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

So this makes the runtime_addr selection work I suppose, but the
runtime_direction still isn't used anywhere, correct?

	Arnd
