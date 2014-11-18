Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaKRAzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:55:13 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:31839 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaKRAzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:55:10 -0500
X-AuditID: cbfee68f-f791c6d000004834-10-546a98ecef15
Message-id: <546A98EC.8090009@samsung.com>
Date: Tue, 18 Nov 2014 09:55:08 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: lee.jones@linaro.org, broonie@kernel.org, mturquette@linaro.org,
        a.zummo@towertech.it, lgirdwood@gmail.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 4/5] rtc: s5m: Add the support for S2MPS13 RTC
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-5-git-send-email-cw00.choi@samsung.com>
 <012401d002c8$04efe610$0ecfb230$@samsung.com>
In-reply-to: <012401d002c8$04efe610$0ecfb230$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsWyRsSkRPfNjKwQgx+LLS2WXLzKbjH14RM2
	i/lHzrFa/JnQymYx6f4EFouzTW/YLe5/Pcpo8e1KB5PF5V1z2CyeTrjIZnG6m9Xi4oovTA48
	Hjtn3WX32LSqk83jzrU9bB7zTgZ69G1Zxegxfd5PJo/Pm+QC2KO4bFJSczLLUov07RK4MnoO
	32UqmMdS8fDhTNYGxnXMXYwcHBICJhIzVwl2MXICmWISF+6tZ+ti5OIQEljKKNF/cS4LRMJE
	4uH1BcwgtpDAIkaJjsNaEEWvGSVezO1kB0nwCmhJPJuxghHEZhFQlej69R6sgQ0ovv/FDTYQ
	W1QgTGLl9CssEPWCEj8m3wOzRQTUJI6cOs8EMpRZoJ9J4vuF62AJYQEniUnzP0GdtJZR4s+C
	6WCTOAWsJO4cXwK2gVlAR2J/6zQ2CFteYvOat8wQZ/9kl1jWpQ1xkYDEt8mHWCBelpXYdACq
	RFLi4IobLBMYxWYhuWkWkqmzkExdwMi8ilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMwck//
	e9a/g/HuAetDjAIcjEo8vAlTs0KEWBPLiitzDzGaAl0xkVlKNDkfmB7ySuINjc2MLExNTI2N
	zC3NlMR5F0r9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAuMiATdWgyXbRtM1C31xv28jk
	Wu4V/sZ4XDR/Z17R8x5VPzbrD49YNJ/bSP75q8uXGT7XammxYp6UB3/b44+2v+XDS9W8tkxc
	aPVzqsn2PUJHdU7We9qVSyYpaxqf9+BJffFsxTkxS7YwKfEj/8R/9c/9Hda8QXTzjmez+E9n
	+8WFbfjl6q+oxFKckWioxVxUnAgAUnKPAtcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jAd03M7JCDGbeMrRYcvEqu8XUh0/Y
	LOYfOcdq8WdCK5vFpPsTWCzONr1ht7j/9SijxbcrHUwWl3fNYbN4OuEim8XpblaLiyu+MDnw
	eOycdZfdY9OqTjaPO9f2sHnMOxno0bdlFaPH9Hk/mTw+b5ILYI9qYLTJSE1MSS1SSM1Lzk/J
	zEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpUSaEsMacUKBSQWFyspG+HaUJo
	iJuuBUxjhK5vSBBcj5EBGkhYw5jRc/guU8E8loqHD2eyNjCuY+5i5OSQEDCReHh9AZQtJnHh
	3no2EFtIYBGjRMdhrS5GLiD7NaPEi7md7CAJXgEtiWczVjCC2CwCqhJdv96DNbMBxfe/uAHW
	LCoQJrFy+hUWiHpBiR+T74HZIgJqEkdOnWcCGcos0M8k8f3CdbCEsICTxKT5n9ggtq1llPiz
	YDrYJE4BK4k7x5eAbWAW0JHY3zqNDcKWl9i85i3zBEaBWUiWzEJSNgtJ2QJG5lWMoqkFyQXF
	Sem5RnrFibnFpXnpesn5uZsYwanhmfQOxlUNFocYBTgYlXh4E6dmhQixJpYVV+YeYpTgYFYS
	4T3XDRTiTUmsrEotyo8vKs1JLT7EaAoMg4nMUqLJ+cC0lVcSb2hsYmZkaWRuaGFkbK4kznuw
	1TpQSCA9sSQ1OzW1ILUIpo+Jg1OqgZFhg8Ns1ng2hj1VjZ2Xb7NOuBFS/bx6rWyj830Pv4IV
	1p1JR7SOiMyqivysvNEgK3rNjICjjw6HONcX/Ny2tF1ba/YDpqdRnGwmp3i9bp/rKJ7eOyn/
	7L3QvMrmOR13fQ/6NrtGKv5j8DK2l5gnlL679mimqfqemN6zfQvO510pdEvaWud0UImlOCPR
	UIu5qDgRAMKbP3MjAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sangbeom,

On 11/18/2014 09:38 AM, Sangbeom Kim wrote:
> Hi,
> On Monday, November 17, 2014 9:43 AM, Chanwoo Choi wrote:
>> This patch adds only the compatible string for S2MPS13 clock which is identical
>> with S2MPS14 clock driver.
> 
> What's the relation of S2MPS14 RTC and clock driver?

I checked the difference between S2MPS13 and S2MPS14.
But, all register (RTC) of both PMICs was the same completely.
So, I just add S2MPS13 type to use existing S2MPS14 RTC feature for S2MPS13 RTC.

Best Regards,
Chanwoo Choi

