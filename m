Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934552Ab3DHQNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:13:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58569 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934339Ab3DHQNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:13:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/5] dmaengine: ste_dma40: Assign memcpy channels in the driver
Date: Mon, 8 Apr 2013 18:13:33 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>
References: <1365434591-21569-1-git-send-email-lee.jones@linaro.org> <1365434591-21569-2-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1365434591-21569-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304081813.33926.arnd@arndb.de>
X-Provags-ID: V02:K0:mdtF/DXzH1w6t0dlYCzwFuxDD8G2vD6qnjH2HeLB/bf
 i+JMkKgwWnDO0JBgeB6ngcLwT+lW1Xs6LXbefJ36l/WddW2Wv0
 1hALHdn5CV5PV0Exdsc3UOiPDZU7HP4vv+CdCwt9SuFR9ds0T8
 52Qcq8TnQx2aH0eoye5v/l2sdxX2o7qVryotatKTPgInnElSuK
 EXRur73kVGslB8EfuSM/iqyhVWl0NRKD4TqEuCdcYgJjIDBwq1
 CSRcXAgBIfZ0EmmjdJLxJHkbIUVzRpXGNQKRhwBU1BNe4sA0VF
 /u6KLbhmmTsagnDUDKtDDKRlzccS6RrAbw7XLdQ3RopZGCP90G
 E+qmBqjp04CwOMDBZIZo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 April 2013, Lee Jones wrote:
> The channels reserved for memcpy are the same for all currently
> supported platforms. With this in mind, we can ease the platform
> data passing requirement by moving these assignments out from
> platform code and place them directly into the driver.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
