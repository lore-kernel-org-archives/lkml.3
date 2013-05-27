Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3E0FiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 01:38:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9219 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab3E0FiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 01:38:10 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-a3-51a2f13fad51
Message-id: <51A2F13F.80703@samsung.com>
Date: Mon, 27 May 2013 14:38:07 +0900
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
Subject: Re: [PATCH 3/3] usb: dwc3: use extcon fwrk to receive
 connect/disconnect notification
References: <1369405896-30246-1-git-send-email-kishon@ti.com>
 <1369405896-30246-4-git-send-email-kishon@ti.com>
In-reply-to: <1369405896-30246-4-git-send-email-kishon@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsWyRsSkSNfh46JAg1n/mCwO3q+3mPrwCZvF
	gdkPWS1OHVzOatG/xcXiwJ8djBbNi9ezWVx42sNmsXTfahaLb1c6mCwWti1hsbi8aw6bxewl
	/SwWi5a1MlvcblzBZnF4xQEmi3Uvp7NYnO5mdRDyWPD5CrvHzll32T02repk83i1eiarx51r
	e9g85p0M9Ng/dw27x/kZCxk9epvfsXn0bVnF6DF1yl9Gj+M3tjN5fN4kF8AbxWWTkpqTWZZa
	pG+XwJWxdOo8poI5rBVzFl9lbGBcz9LFyMkhIWAi8X5eLxuELSZx4d56IJuLQ0hgKaPEnQuL
	2WGKpl1cxwiRmM4o0TfvNCNIQkjgBaPEhwtMIDavgIbEjQ+rwRpYBFQlnm/vA5vKJqAlsf/F
	DTBbVCBMYuX0KywQ9YISPybfA7NFgGpO7/zBDGIzC6xmlmjaHNbFyMEhLJAgMfV8NogpJFAo
	seEsH0gFp4CdxMaDD9kgqnUk9rdOg7LlJTavecsMcfIVDonJq1khrhGQ+Db5EAvIGAkBWYlN
	B6BKJCUOrrjBMoFRbBaSe2YhmToLydQFjMyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MQLT
	xOl/z3p3MN4+YH2IMRlo5URmKdHkfGCaySuJNzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QDY0/wuyWZ+/cwJBg0lrcqvgxoDn/bKZy73HdlD9uKL46K
	/HzNAmZZYea+Xkn5B8867quLSwhZdXXC5daWXysFpU/bGvbNUSvYI3v9rKbP9JWGJ2U+xj9j
	UbgVPH1Zl9qcv+7L3IvCG+PsgkySJrXtXxD+trdmReSmmqQ3vBM+vVzKueVy6r/FSizFGYmG
	WsxFxYkA4MhD3CkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCKsWRmVeSWpSXmKPExsVy+t9jQV37j4sCDVZ1mlscvF9vMfXhEzaL
	A7MfslqcOric1aJ/i4vFgT87GC2aF69ns7jwtIfNYum+1SwW3650MFksbFvCYnF51xw2i9lL
	+lksFi1rZba43biCzeLwigNMFuteTmexON3N6iDkseDzFXaPnbPusntsWtXJ5vFq9UxWjzvX
	9rB5zDsZ6LF/7hp2j/MzFjJ69Da/Y/Po27KK0WPqlL+MHsdvbGfy+LxJLoA3qoHRJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoRSWFssScUqBQQGJx
	sZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxtKp85gK5rBWzFl8lbGBcT1LFyMnh4SAicS0
	i+sYIWwxiQv31rN1MXJxCAlMZ5Tom3caLCEk8IJR4sMFJhCbV0BD4saH1ewgNouAqsTz7X1s
	IDabgJbE/hc3wGxRgTCJldOvsEDUC0r8mHwPzBYBqjm98wcziM0ssJpZomlzWBcjB4ewQILE
	1PPZIKaQQKHEhrN8IBWcAnYSGw8+ZIOo1pHY3zoNypaX2LzmLfMERoFZSBbMQlI2C0nZAkbm
	VYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBaeiZ9A7GVQ0WhxgFOBiVeHgXzFgUKMSaWFZc
	mXuIUYKDWUmENyEaKMSbklhZlVqUH19UmpNafIgxGej/icxSosn5wBSZVxJvaGxiZmRpZG5o
	YWRsTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MTd84hIuXdx0y82++YP06Y+4koQQF
	R/PCOcdLVoYk5FbPnVz+4G/Qz1UngiSKzZdw8Re/25tywIDfe0dkyHHhD1diFqyVWuYduV7h
	TupLm6qPunuWb/571O+PtNf8kKwF1yYdTViR59Szsvo876+sHy+cstYt2BC4eHrW4l/BcYut
	vjS9faooqcRSnJFoqMVcVJwIABOZP7CHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 11:31 PM, Kishon Vijay Abraham I wrote:
> Modified dwc3-omap to receive connect and disconnect notification using
> extcon framework. Also did the necessary cleanups required after
> adapting to extcon framework.
>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/dwc3/dwc3-omap.c  | 80 +++++++++++++++++++++++++++++++++----------
>  include/linux/usb/dwc3-omap.h | 30 ----------------
>  2 files changed, 62 insertions(+), 48 deletions(-)
>  delete mode 100644 include/linux/usb/dwc3-omap.h
>
>
I check the code about extcon framework.

Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi
