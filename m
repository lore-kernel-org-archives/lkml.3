Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaCMJpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:45:04 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39033 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbaCMJo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:44:59 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-25-53217e1acdd5
Message-id: <1394703896.6546.2.camel@AMDC1943>
Subject: Re: [PATCH v3 3/4] mfd: max8997: change irq names to upper case
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, dmitry.torokhov@gmail.com, cooloney@gmail.com,
        rpurdie@rpsys.net, dbaryshkov@gmail.com, dwmw2@infradead.org,
        lgirdwood@gmail.com, broonie@kernel.org, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com
Date: Thu, 13 Mar 2014 10:44:56 +0100
In-reply-to: <1394703532-494-4-git-send-email-r.baldyga@samsung.com>
References: <1394703532-494-1-git-send-email-r.baldyga@samsung.com>
 <1394703532-494-4-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t/xK7pSdYrBBvObmCyWXLzKbjH14RM2
	i6M7JzJZXP/ynNVi0pP3zBaHF71gtJi4cjKzxf2vRxktvl3pYLK4+ekbq8XlXXPYLLa+Wcdo
	sfbIXXaL240r2Cyu7T3ObPHg8E52i927nrJa7O/sYLQ43c3qIOyxc9Zddo89E0+yeWxeoeWx
	aVUnm8eda3vYPOadDPTYM/8Hq0ffllWMHtPn/WTy+LxJzmP9lq1MAdxRXDYpqTmZZalF+nYJ
	XBk7Lr1nKXjBUrF7wymmBsZ/zF2MnBwSAiYSdxY+Y4OwxSQu3FsPZHNxCAksZZS4/vEUO4Tz
	mVHi8b+pjCBVvAJ6Eu1XpoB1CAt4SJzecZIdxGYTMJbYvHwJWFxEQEvizsf5YM3MAoeZJfY9
	6GAFSbAIqEr0X+0FW80p4CJx/MVvJhBbSKBW4n3TfzCbWUBdYtK8RVDnKUnsbu9kh4jLS2xe
	85YZ4ghBiR+T77FMYBSYhaRlFpKyWUjKFjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P3cQI
	icuvOxiXHrM6xCjAwajEwxuwVCFYiDWxrLgy9xCjBAezkgjv/ErFYCHelMTKqtSi/Pii0pzU
	4kOMTBycUg2MLEe+vn7a7NLbe+HxZqEXJ/9PvPFM8XBxQu+Njvvi8462Jtp8+uubfLTuxVu7
	zj3dWmtuntUzjXC6U7dJgrX9tsKX/9w2q5uE7M9e67ib0OYWkB9Z/7DwiPb/1Rva2pYa+mpP
	cVktKmnz9snmz+L63//r7GaPecG/PcUmUui3jNHivKSAW1u9lViKMxINtZiLihMBSCFUlqkC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 10:38 +0100, Robert Baldyga wrote:
> This patch changes naming convention of MUIC interrupts form CamelCase
> to upper case. It makes names more readable and consistent with another
> interrupt names in max8997 driver.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/extcon/extcon-max8997.c     |   32 ++++++++++++++++----------------
>  include/linux/mfd/max8997-private.h |   16 ++++++++--------
>  2 files changed, 24 insertions(+), 24 deletions(-)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>


Best regards,
Krzysztof Kozlowski

