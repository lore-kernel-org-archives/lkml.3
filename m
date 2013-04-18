Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968294Ab3DRKzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:55:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63881 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967253Ab3DRKzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:55:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 16/32] dmaengine: ste_dma40: Remove unnecessary call to d40_phy_cfg()
Date: Thu, 18 Apr 2013 12:55:44 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <1366279934-30761-17-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366279934-30761-17-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181255.44950.arnd@arndb.de>
X-Provags-ID: V02:K0:6d2rd2BgqzIBk6TNZ81EBQUYBkbI2eh0AGukAl8k48U
 T9XWzFwrZw0YmLyP7vSLWFmAoSi8aQU1KO7Y2Wrxi1MS5ejfjx
 4wK0prZWep85L6uuSo03JBFVKAUeNY3ERMcWSsJBJpfEDZTaZc
 GVyDfeox96Com7163Tozn7DyFPtHgeRVV2ReK+bxYQx9cMr4NS
 qZiWUkj+seTrTtR0LuqsYa8DqDvsxy5ukwOHEJGfk9vbd8a/FO
 qQac6N8Plfih8KbOujhXY7aW/6VUb2mFMyes6iDbzOQBQS3PR/
 iLZvv22XTV5QN4fidwKE0eM5t5Dr4BJ8ZwTbPMS/AWIDYQt9WQ
 BSz2HYPF5tjzFEiCswqI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Lee Jones wrote:
> All configuration left in d40_phy_cfg() is runtime configurable and
> there is already a call into it from d40_runtime_config(), so let's
> rely on that.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
