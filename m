Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaCCIAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:00:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37896 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbaCCIAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:00:14 -0500
X-AuditID: cbfee68f-b7f156d00000276c-92-5314368c7c66
Message-id: <5314368B.4040707@samsung.com>
Date: Mon, 03 Mar 2014 17:00:11 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        "'Graeme Gregory'" <gg@slimlogic.co.uk>
Subject: Re: [PATCH 1/2] extcon: palmas: Use SIMPLE_DEV_PM_OPS macro
References: <000801cf33b0$1f9876e0$5ec964a0$%han@samsung.com>
In-reply-to: <000801cf33b0$1f9876e0$5ec964a0$%han@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWyRsSkWLfHTCTY4O0EQYv+LS4WlxdeYrW4
	vGsOm8XtxhVsDiwefVtWMXpMnfKX0ePzJrkA5igum5TUnMyy1CJ9uwSujMdL17EX3GSqWLR0
	G2MD40SmLkYODgkBE4n1H3i6GDmBTDGJC/fWs3UxcnEICSxllDjaOJ8NImEisfT3ChaIxHRG
	iUdXpzNDOK8YJdb8fMsOMolXQEti//cAkAYWAVWJyzdPM4PYbCDhFzfABokKhEmsnH6FBcTm
	FRCU+DH5HpgtIqAi8Xn9cbAaZoESiXWvD4PFhQVcJN4828QEYgsJ2EpcOb8ALM4pYCex4NMD
	Foh6HYn9rdOgeuUlNq95C3abhMAydomTn1YzQhwkIPFt8iEWiI9lJTYdYIZ4TFLi4IobLBMY
	xWYhOWkWkrGzkIxdwMi8ilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMwgk7/e9a/g/HuAetD
	jMlAKycyS4km5wMjMK8k3tDYzMjC1MTU2Mjc0ow0YSVx3vsPk4KEBNITS1KzU1MLUovii0pz
	UosPMTJxcEo1MPqp5uYWGAtVFPWy7ekNEH0befvGhj8/m6YeYs9fuG2mVZla3pSf7z6eecqy
	I5elpfzgDdOJGcEFL3/o8ew5+KfUZ+pRIeMdn/UedRzZxdTlknTf9vCjTQcLijj+ydYXvpxs
	GcrX+dlqRtPumJ9G51dJyVQe0+HM8Hm0Jdo+dE20vJffx0+mLkosxRmJhlrMRcWJAPbP0Iy2	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xoG6PmUiwwe9mLov+LS4WlxdeYrW4
	vGsOm8XtxhVsDiwefVtWMXpMnfKX0ePzJrkA5qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4
	UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoG1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1D
	guB6jAzQQMIaxozHS9exF9xkqli0dBtjA+NEpi5GTg4JAROJpb9XsEDYYhIX7q1n62Lk4hAS
	mM4o8ejqdGYI5xWjxJqfb9m7GDk4eAW0JPZ/DwBpYBFQlbh88zQziM0GEn5xgw3EFhUIk1g5
	/QrYUF4BQYkfk++B2SICKhKf1x8Hq2EWKJFY9/owWFxYwEXizbNNYAcJCdhKXDm/ACzOKWAn
	seDTAxaIeh2J/a3ToHrlJTavecs8gVFgFpIVs5CUzUJStoCReRWjaGpBckFxUnquoV5xYm5x
	aV66XnJ+7iZGcIQ+k9rBuLLB4hCjAAejEg9vx3LhYCHWxLLiytxDjBIczEoivPnLgEK8KYmV
	ValF+fFFpTmpxYcYk4EhMJFZSjQ5H5g88kriDY1NzIwsjcwNLYyMzUkTVhLnPdBqHSgkkJ5Y
	kpqdmlqQWgSzhYmDU6qB0Vk7ySYyfJLJopUKH5+U9Ob1RKr58BTrb1+gFOz95gxn8kX3wuP/
	Ffh5J9Rnn7tpIfpkUry7aP6vt1ryrqox23PeTmg79CdwbZHhbrF1nRuU9tWWfV1eor3g664E
	8/U6trFv1j1V75hfuvBk+HmOL68ll7raCB3MLXj5dUr+t62ByubPk7efVmIpzkg01GIuKk4E
	AICFvfwUAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 08:36 PM, Jingoo Han wrote:
> Use SIMPLE_DEV_PM_OPS macro in order to make the code simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/extcon/extcon-palmas.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 

Applied patch1/2 on extcon-linus branch.

Thanks,
Chanwoo Choi

