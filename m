Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3IWG0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 02:26:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31920 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3IWG0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 02:26:46 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-35-523fdf24670f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Felipe Balbi'" <balbi@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1379907508-22492-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1379907508-22492-1-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH] usb: dwc3: Remove additional delay of 100ms when resuming
Date: Mon, 23 Sep 2013 15:26:44 +0900
Message-id: <000001ceb825$dfae0eb0$9f0a2c10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64DpwzhnS6AcgRRf61bxtim5SwsAAFnboA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zI13V+/ZBBic+MFocvF9v8fKQpkXb
	lYPsFs2L17NZXF54idXi8q45bBazl/SzWMw4v4/JYtGyVmYHTo/9c9ewe/RtWcXocfzGdiaP
	z5vkAliiuGxSUnMyy1KL9O0SuDI27ogr+M9V8a7vAlsD40uOLkZODgkBE4mV02ezQdhiEhfu
	rQeyuTiEBJYxSmy60cgGU3S1aTsjiC0kMJ1R4uMuCYiiX4wSZw+fZwJJsAmoSXz5cpgdxBYR
	0JXomfiRBaSIWeAHo8Tl2X+huj0kjs9fBdbAKeApsfDUc7AGYQE/iS0bfzCD2CwCqhJtVzeD
	1fMK2EpcObeFDcIWlPgx+R4LiM0soCWxfudxJghbXmLzmrdAvRxAl6pLPPqrC3GDkcS1xhXM
	ECUiEvtevGMEuUdC4CO7xLEVs5ggdglIfJt8iAWiV1Zi0wFmiIclJQ6uuMEygVFiFpLNs5Bs
	noVk8ywkKxYwsqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECInh3h2Mtw9YH2JMBlo/kVlK
	NDkfmALySuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp
	1cBYKRrSqDX31uWNPzMEJcQCDk0M33Fb9ZChxcyI0KyEjby+uaI+x4I28kxli59lNids7eXk
	xcxGpzZxi8wQ+p//Y0nqydNSFyy9D9yWtl2hW7po3d4VVvlcIU9+5XbuTZ1d8/bPzdNdV5bu
	e8HUE3ZExLie5WuXykpBXS/bFLvrf7MiZ/aebvqtxFKckWioxVxUnAgA1+2F9fcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jQV2V+/ZBBm9vWlocvF9v8fKQpkXb
	lYPsFs2L17NZXF54idXi8q45bBazl/SzWMw4v4/JYtGyVmYHTo/9c9ewe/RtWcXocfzGdiaP
	z5vkAliiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0y
	c4BOUVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmbNwRV/Cfq+Jd3wW2
	BsaXHF2MnBwSAiYSV5u2M0LYYhIX7q1nA7GFBKYzSnzcJdHFyAVk/2KUOHv4PBNIgk1ATeLL
	l8PsILaIgK5Ez8SPLCBFzAI/GCUuz/7LCNHtIXF8/iqwBk4BT4mFp56DNQgL+Els2fiDGcRm
	EVCVaLu6GayeV8BW4sq5LWwQtqDEj8n3WEBsZgEtifU7jzNB2PISm9e8BerlALpUXeLRX12I
	G4wkrjWuYIYoEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1ya
	l66XnJ+7iRGcIJ5J7WBc2WBxiFGAg1GJhzci0T5IiDWxrLgy9xCjBAezkghvUydQiDclsbIq
	tSg/vqg0J7X4EGMy0KMTmaVEk/OBySuvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp
	2ampBalFMFuYODilGhiNk+1L9zwTjElSu+N2InznesXTRz1n2P35cyUtr4C5jknzhaZRx+Qr
	0T8eGnRss8rys8u+HGPF75Ueu6lOyvjqPhlXWd6WT/FX+fdxVQrt35MUtbHkYGraCtnFB33P
	nJ8hInn0hdrZfzcUJCxeJIZyBR3rYDzZGta24++ee/8YX33dLce2tl6JpTgj0VCLuag4EQDc
	eRvvVAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 23, 2013 12:38 PM, Vivek Gautam wrote:
> 
> This delay got introduced in:
> "7415f17 usb: dwc3: core: add power management support"
> which reflected similar code in dwc3_core_soft_reset() function.
> However, originally the delay of 100ms in dwc3_core_soft_reset() was
> meant to assist USB2PHY and USB3PHY reset, not for usb_phy_init()
> sequence.
> 
> We should get rid of this delay, since things will still work
> fine without this.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

OK, I see.
There is no reason to add msleep(100) to dwc3_resume();
thus, this msleep(100) can be removed.

Best regards,
Jingoo Han

> ---
> 
> Hi Felipe,
> 
> I remember this change for phy_init including msleep(100) was
> suggested by me, after testing the patch-series for PM support
> to dwc3.
> Sorry for that !!
> 
>  drivers/usb/dwc3/core.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 474162e..e88ffae 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -691,7 +691,6 @@ static int dwc3_resume(struct device *dev)
> 
>  	usb_phy_init(dwc->usb3_phy);
>  	usb_phy_init(dwc->usb2_phy);
> -	msleep(100);
> 
>  	spin_lock_irqsave(&dwc->lock, flags);
> 
> --
> 1.7.6.5


