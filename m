Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609Ab3DHQOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:14:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62110 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934330Ab3DHQOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:14:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 3/5] dmaengine: ste_dma40: Move default memcpy configs into the driver
Date: Mon, 8 Apr 2013 18:14:00 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>
References: <1365434591-21569-1-git-send-email-lee.jones@linaro.org> <1365434591-21569-3-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1365434591-21569-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304081814.00868.arnd@arndb.de>
X-Provags-ID: V02:K0:CWVmOjeNR7kD49tHQecQaE6aC5q1W3LdEA0hk0fWrKT
 T919WgOdHjYNwp6J0kC6cqjtvnIDJxNUOgQOjWo/9VJZa+uMDo
 uD+kgci+aBXK15AQllZDhlPbF0h7T1jIxX/0yVHajtMe8wzTLe
 5dMvlcKSlvQa3cFrjWPEMINr1T8a6aqTtP0DzXppMQQCbEdnc1
 azhY6FLBUyb3n8pit/TlFJGx9mCmC8uaigeon/N/A1eCQVvVk9
 TT7kjie4z+MwdD/EA3B3miy41msvJniR9fYxpk84uefOfdKCJe
 Xiz2FLVkzMps37Hx5dFkCnWoW55y8xttH04CVIkztrFyqLPW47
 2+4lMf8Fgz9fjrWsAzMU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 April 2013, Lee Jones wrote:
> There are only two default memcpy configurations used for the DMA40
> driver; one for physical memcpy and one for logical memcpy. Instead
> of invariably passing the same configurations though platform data,
> we're moving them into the driver instead.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
