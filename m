Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaJ1VL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:11:59 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:54503 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbaJ1VL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:11:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, olof@lixom.net,
        khilman@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: multi_v7_defconfig: fix support for APQ8084
Date: Tue, 28 Oct 2014 22:11:48 +0100
Message-ID: <15749942.RHYUJy9s6B@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413917720-17069-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1413917720-17069-1-git-send-email-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:U70YzUkISxc6vIqeGmBx07+Rc3fAaZfqGBSVPkAoltW
 1u0ckE6glcgOm5BNbz01Ahu40WkChYm4XWNVGG4GoG2ASfOpwT
 1zSBtbDwRLKsw7uDYT5Q0AzcX4t/IcR1LdAY8b25Z2+CDJ/e64
 rA3pNM2fWH8/GaC5W0cwYPdouBS2DxFhAnwvIoOHTbCHg5xj8g
 968N+P9gmR35UV8g4mjYr8xVCC2sNpzbUY13lDiw4xbDr2t8zk
 1G2/onZmEEqC9xsCdOy5mYkI9UxArntxP7VHXZBLClO9nG0bZF
 SwrqqRxB5T6CszdpVtcwN0dgDzfJxVlcG23WGOrT5//2CictCm
 MeQDX9X3ROQeyHt/uV6M=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 October 2014 19:55:20 Srinivas Kandagatla wrote:
> This patch enables configs required to boot IFC6540 board with atleast a
> serial console.
> 
> Without this patch there is no serial console.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> 

It wasn't really clear from your email what you expected to happen with this
patch. I've picked it up in the fixes branch for 3.18 now, as it seemed
to fit that category.

	Arnd
