Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab3E1CYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 22:24:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41291 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557Ab3E1CY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 22:24:27 -0400
X-AuditID: cbfee691-b7fef6d000002d62-4a-51a41559d09a
Message-id: <51A41559.20808@samsung.com>
Date: Tue, 28 May 2013 11:24:25 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: myungjoo.ham@samsung.com, balbi@ti.com, ldewangan@nvidia.com,
        gg@slimlogic.co.uk, lgirdwood@gmail.com, broonie@kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, gregkh@linuxfoundation.org,
        george.cherian@ti.com, sameo@linux.intel.com
Subject: Re: [PATCH v2] usb: dwc3: use extcon fwrk to receive
 connect/disconnect notification
References: <1369405896-30246-1-git-send-email-kishon@ti.com>
 <1369661740-15966-1-git-send-email-kishon@ti.com>
In-reply-to: <1369661740-15966-1-git-send-email-kishon@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsWyRsSkUDdSdEmgwYT3ghYH79dbTH34hM3i
	wOyHrBanDi5ntejf4mJx4M8ORovmxevZLC487WGzWLpvNYvFtysdTBYL25awWFzeNYfNYvaS
	fhaLRctamS1uN65gszi84gCTxbqX01ksTnezOgh5LPh8hd1j56y77B6bVnWyebxaPZPV4861
	PWwe804Geuyfu4bd4/yMhYwevc3v2Dz6tqxi9Jg65S+jx/Eb25k8Pm+SC+CN4rJJSc3JLEst
	0rdL4Mo4uuI/e8FNtop1vz+wNDCeZu1i5OSQEDCRWDhlGpQtJnHh3nq2LkYuDiGBpYwSZ5re
	MMIU7dj2ihEisYhRovfWYnYI5wWjROe9kywgVbwCGhKnPl8AG8UioCrx//ZUsG42AS2J/S9u
	sIHYogJhEiunX4GqF5T4MfkemC0CVHN65w9mEJtZYDWzRNPmMBBbWCBeYu++n2BzhAQKJfZO
	f8AOYnMK2Encm/GJFaJeR2J/6zQ2CFteYvOat8wgx0kIXOGQeLnsJxvEQQIS3yYfAlrGAZSQ
	ldh0gBniM0mJgytusExgFJuF5KRZSMbOQjJ2ASPzKkbR1ILkguKk9CJTveLE3OLSvHS95Pzc
	TYzAdHH637OJOxjvH7A+xJgMtHIis5Rocj4w3eSVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0o
	JJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTHoXguL0qF1M+5teLB+ctmRIG7Hy3KWF+OzT1wS
	tFzd9WE2qytfE9fBhYX2itnzNJaWyW3253zaa3lv+pYVf7b6nFxt9bvOsF+hrmVaM8fL3iM6
	p7+UrXH9uu1s7q/Pd7wjnud2KnxwCz58f9XEqx+tf6yYvaBb5INZVvcGjk9FKiXnr18Tbl+v
	xFKckWioxVxUnAgAZ9vOlS0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsVy+t9jAd1I0SWBBk9ec1gcvF9vMfXhEzaL
	A7MfslqcOric1aJ/i4vFgT87GC2aF69ns7jwtIfNYum+1SwW3650MFksbFvCYnF51xw2i9lL
	+lksFi1rZba43biCzeLwigNMFuteTmexON3N6iDkseDzFXaPnbPusntsWtXJ5vFq9UxWjzvX
	9rB5zDsZ6LF/7hp2j/MzFjJ69Da/Y/Po27KK0WPqlL+MHsdvbGfy+LxJLoA3qoHRJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoRSWFssScUqBQQGJx
	sZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxtEV/9kLbrJVrPv9gaWB8TRrFyMnh4SAicSO
	ba8YIWwxiQv31rN1MXJxCAksYpTovbWYHcJ5wSjRee8kC0gVr4CGxKnPF8C6WQRUJf7fngrW
	zSagJbH/xQ02EFtUIExi5fQrUPWCEj8m3wOzRYBqTu/8wQxiMwusZpZo2hwGYgsLxEvs3fcT
	bI6QQKHE3ukP2EFsTgE7iXszPrFC1OtI7G+dxgZhy0tsXvOWeQKjwCwkK2YhKZuFpGwBI/Mq
	RtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBk9Ex6B+OqBotDjAIcjEo8vBOyFwcKsSaWFVfm
	HmKU4GBWEuHdvgIoxJuSWFmVWpQfX1Sak1p8iDEZGAITmaVEk/OBiTKvJN7Q2MTMyNLI3NDC
	yNicNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhhXdnk9nhi4MuxyZ8Hqcz9VFur9Vuup
	v/fRSPWnsIIaq5CbmElwZJt09jot75wj7w/EF5snsb6Z7229/kLOycPO81q8HwtaG3P/07de
	8HGBmoif5vqjz+/WHviX0x192dN/wf/snxsjJa9LHW7lk78w/cJO4W4h4WPmszle8Kiciqvi
	mfhI6IUSS3FGoqEWc1FxIgBUspJKigMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 10:35 PM, Kishon Vijay Abraham I wrote:
> Modified dwc3-omap to receive connect and disconnect notification using
> extcon framework. Also did the necessary cleanups required after
> adapting to extcon framework.
>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
> Changes from v1:
> * regulator enable/disable is now done here instead of palmas-usb as some users
> of palmas-usb wont need regulator.
>  drivers/usb/dwc3/dwc3-omap.c  | 103 ++++++++++++++++++++++++++++++++++--------
>  include/linux/usb/dwc3-omap.h |  30 ------------
>  2 files changed, 85 insertions(+), 48 deletions(-)
>  delete mode 100644 include/linux/usb/dwc3-omap.h
I think that usb or other maintainer have to confirm this patch
for applying extcon-next branch.

Thanks,
Chanwoo Choi
