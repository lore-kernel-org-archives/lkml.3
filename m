Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937638Ab3DIK2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:28:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935614Ab3DIK2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:28:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 4/5] dmaengine: ste_dma40: Do not configure channels during an channel allocation
Date: Tue, 9 Apr 2013 12:28:01 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>
References: <1365434591-21569-1-git-send-email-lee.jones@linaro.org> <1365434591-21569-4-git-send-email-lee.jones@linaro.org> <20130409071154.GH3084@gmail.com>
In-Reply-To: <20130409071154.GH3084@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304091228.01896.arnd@arndb.de>
X-Provags-ID: V02:K0:0vaD0ZXMYrhDaSnK+UysdNtjm7I1ZTF8DbURNOu1Ej0
 KjB6ol+pH2TuRJ/17jymjPTewK3XPa2BYpG0NyHe0yvoMcwkal
 fOn5ar/8Rt4ybS6pI1EEcDtZGAuYLjOdB/tURrTmVJBTftSMJw
 Iwmw/Yv36bX8HosDo47PWubI/ONBUM6Hid2rtJ0V79kQKhYmfY
 7lkSNwCblxJx5Xn13yQ/SenGTiSSYfyUOqUafv7Yx0ufCD+GFC
 GWO6L9Oz66ajb/bI9nidIEsWho/82rhQH1ZJGR1cIJUvR3B+/M
 KtJbNUlUnQmOO8rLmrDLw5j1x/G0pjdMbqfUHUW4nmCrdqaqJt
 02EqkZLTOXCd/FxGC9cY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Lee Jones wrote:
> According to the DMA documentation allocating a channel and configuring
> it are two separate actions. By removing the configuration code from the
> channel allocation path we lighten the burden on the information required to
> successfully allocate a channel.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
