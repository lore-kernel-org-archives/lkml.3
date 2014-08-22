Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbaHVROV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:14:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17626 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbaHVROR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:14:17 -0400
X-AuditID: cbfee61a-f79e46d00000134f-0b-53f77a666a42
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: balbi@ti.com
Cc: Kukjin Kim <kgene.kim@samsung.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] usb: phy: samsung: remove old USB PHY code
Date: Fri, 22 Aug 2014 19:14:11 +0200
Message-id: <9785858.kcvmMFDl1x@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140820181244.GX24500@saruman.home>
References: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
 <20140820181244.GX24500@saruman.home>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jQd20qu/BBh8X6lscvF9vsen6dVaL
	tisH2S1+vL7AZtG74CqbxYWnPWwWZ5vesFtc3jWHzWLG+X1MFouWtTI7cHncubaHzaNvyypG
	j+M3tjN5fN4kF8ASxWWTkpqTWZZapG+XwJXRc/AdS8FvzooFL0+zNTC+Ze9i5OSQEDCR6J57
	ggXCFpO4cG89WxcjF4eQwHRGif2T/zJBOC1MEg+O7QHrYBOwkpjYvooRxBYREJBY/+ISO0gR
	s8AZJokdvx+BJYQFnCV6dr0Aa2ARUJXofbSQFcTmFdCUaDrXCRYXFfCU2LF9JRuIzSlgJPF7
	1VKgOAfQtgKJ93dzIMoFJX5Mvgd2HbOAvMS+/VNZIWwdif2t09gmMArMQlI2C0nZLCRlCxiZ
	VzGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEB/4zqR2MKxssDjEKcDAq8fAaeHwPFmJNLCuu
	zD3EKMHBrCTCK10IFOJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbL
	xMEp1cBYv3Ci16q7px/ahQUcip4lEbm8ifHi9c+fXxgaCTwui5wdP8Em2qNM4NSfPRP+6vT0
	7pQXMHl1h9nF9KFganhhbZ7Tvj83D/jvYnz1YqX+1Zb/JawpNvKxn65tt7rV7zn1Qe/hX1bz
	ny/76aLrWnSw8ce/1P3lU2/XLCi0WOy42u9i5tpPpem6SizFGYmGWsxFxYkAItlwV3gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, August 20, 2014 01:12:44 PM Felipe Balbi wrote:
> Hi,
> 
> On Thu, Aug 14, 2014 at 04:25:22PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > Hi,
> > 
> > This patch series removes the old Samsung USB PHY drivers that
> > got replaced by the new ones using the generic PHY layer.
> > 
> > Depends on:
> > - next-20140813 branch of linux-next kernel
> 
> this thread seems to have died, what do I need to do with these patches?

Please apply them (patches #3, #4 and #5).  Patches #1 and #2
should be applied (or Acked-by) by Kukjin Kim.

> Are we deleting the phy drivers or not ?

Yes, we are deleting them.  It has been agreed on by Kishon and
Vivek.

> Please rebase on v3.17-rc1 and resend with all Acks in place.

Done:

	https://lkml.org/lkml/2014/8/22/446

Please note that if you want to apply it to current -next kernel
(next-20140822) then you need to resolve conflict between patch
#5/5 ("usb: phy: samsung: remove old common USB PHY code") and
commit bbc66e140bab ("usb: phy: samsung: Fix wrong bit mask for
PHYPARAM1_PCS_TXDEEMPH") by simply removing the new version of
drivers/usb/phy/phy-samsung-usb.h file.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

