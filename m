Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968246Ab3DRKu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:50:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50040 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967094Ab3DRKuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:50:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 05/32] dmaengine: ste_dma40: Supply macros to resolve 'src' and 'dst' directions
Date: Thu, 18 Apr 2013 12:50:50 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <1366279934-30761-6-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366279934-30761-6-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181250.50647.arnd@arndb.de>
X-Provags-ID: V02:K0:vjyflHv10xCSwJFrp7EOz0jRfUHPeJxYT0vR/BDhpJr
 wgkvyK2ZUWVyQe/ePlSkl9FW7XH5pPpgqxOVDMq1YHNeKNNBay
 dTVxkjJMNaZ87b+88rY/gqxtvCWumjgR7LCkzTfbcqgHLbrdpC
 7piMnrbNEpwWz0csZZVqVVX+B9z/yBlLXCvwaSBQ4n9CtS64WO
 9nnYiIQzAvJtZMA3+/yRTivaqdq2Ra1VHhK4A7RVOaD80husUC
 yAbNQstJzW8Y04pVsbBYrQA7I3AcOd/hC1qlByUV5LxT6zLVro
 M8+7ZPNZsHpzoUMTeoXRxLpmIliXH3LrzobCXbCBkDxnCW+DC0
 i1wEkeX9UdX6joceD1xw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Lee Jones wrote:
> +#define D40_IS_SRC(dir)  ((dir == STEDMA40_PERIPH_TO_MEM) ? true : false)
> +#define D40_IS_DST(dir) (((dir == STEDMA40_MEM_TO_PERIPH) || \
> +                         (dir == STEDMA40_MEM_TO_MEM)) ? true : false)
> +

The redundant "? true : false" part is redundant. ;-)

Otherwise the patch looks good.

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
