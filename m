Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645Ab3EAK2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 06:28:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758915Ab3EAK2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 06:28:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/5 v2] dmaengine: ste_dma40: Allow memcpy channels to be configured from DT
Date: Wed, 1 May 2013 12:27:32 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
References: <1367336497-10650-1-git-send-email-lee.jones@linaro.org> <20130501095243.GD25256@gmail.com>
In-Reply-To: <20130501095243.GD25256@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305011227.33117.arnd@arndb.de>
X-Provags-ID: V02:K0:F4bhuZOuzKiyd98zfdAXf12g+vA0tpQBNp5SqNGhlvh
 yI3BazU583pzTlp+U8AO7mNBf29+4g7xZA4w217dCLg7ib6uIp
 cIrkzstyIM4ZsvcczmXeQs16KhckDpzaIDvZ7yWCFeT1B3LUGG
 o92/mSbEqGK9m1KAkUzLmdJclFCBxqdTe6FTLuhj4SNrdjOGIl
 TUifOc6TCdTJgMVIMMbc+kdhbdHAMFSD7XnAorIj9jpLXJXS8h
 K0IQ27rL0jxYto8bRrmIGwkr4KOvDp0Pm4FEmXUc9pbhunYyYt
 7SYEPj8G2cPr7yTNJ4dfDymi8ase7KCBvTaRL+1ZrTlTMALD8X
 2Ew2HY9zf+0jyw1DaRok=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 May 2013, Lee Jones wrote:
> At this moment in time the memcpy channels which can be used by the D40
> are fixed, as each supported platform in Mainline uses the same ones.
> However, platforms do exist which don't follow this convention, so
> these will need to be tailored. Fortunately, these platforms will be DT
> only, so this change has very little impact on platform data.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
