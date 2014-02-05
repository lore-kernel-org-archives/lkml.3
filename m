Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaBEAnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:43:15 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:54729 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaBEAnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:43:13 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-1c-52f18920a858
Message-id: <52F18920.1070400@samsung.com>
Date: Wed, 05 Feb 2014 09:43:12 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 06/18] extcon: max14577: Change extcon name instead of
 static name according to device type
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-7-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1390911522-28209-7-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsWyRsSkSFeh82OQwf+l/BZTHz5hs3j9wtDi
	bNMbdov7X48yWny70sFksenxNVaLy7vmsFmsPXKX3eJ24wo2i9PdrA5cHjtn3WX32LSqk83j
	zrU9bB7zTgZ6bF5S79G3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZy7YtYyzYwFKx9fRNlgbG
	K8xdjJwcEgImEhsnnWKCsMUkLtxbz9bFyMUhJLCUUeLI+5OMMEV//70BKxISWMQoce5TNUTR
	K0aJl7tOs4MkeAW0JM42HQabyiKgKvH4/zmwOBtQfP+LG2wgtqhAmMTK6VdYIOoFJX5Mvgdm
	iwgYShzcvR1sAbPAfSaJVUd0QGxhgUKJd+e2s0Isa2WUWHDgJdhQTgEPiQfb9rNDNOhI7G+d
	xgZhy0tsXvOWGaRBQuAlu8TZ+U1MEBcJSHybfAhoGwdQQlZi0wGo9yUlDq64wTKBUWwWkptm
	IRk7C8nYBYzMqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzECY/T0v2cTdzDeP2B9iDEZaOVE
	ZinR5HxgjOeVxBsamxlZmJqYGhuZW5qRJqwkzpv+KClISCA9sSQ1OzW1ILUovqg0J7X4ECMT
	B6dUA6PHrbTTDVnqv+4X6BX1lhQXcxnweckkJPp+eXd9wfEHk10+PMo51ztt5+4V91aYmBb7
	W8hEqBxwnVPq41V0/N+Lr/tstwdNWNGo5nTaOEFjl5C8v2Wqwbqp9Svm/C1auuLuCymmLFne
	gMynW//fnlxwtSpnw22v49LHZ8V4yrvs2+bwLVzbo0KJpTgj0VCLuag4EQDkLeJN5wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jAV2Fzo9BBpdXsFtMffiEzeL1C0OL
	s01v2C3ufz3KaPHtSgeTxabH11gtLu+aw2ax9shddovbjSvYLE53szpweeycdZfdY9OqTjaP
	O9f2sHnMOxnosXlJvUffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7H
	yAANJKxhzFi2bRljwQaWiq2nb7I0MF5h7mLk5JAQMJH4++8NE4QtJnHh3no2EFtIYBGjxLlP
	1V2MXED2K0aJl7tOs4MkeAW0JM42HQZrZhFQlXj8/xxYnA0ovv/FDbBmUYEwiZXTr7BA1AtK
	/Jh8D8wWETCUOLh7O9gyZoH7TBKrjuiA2MIChRLvzm1nhVjWyiix4MBLsKGcAh4SD7btZ4do
	0JHY3zqNDcKWl9i85i3zBEaBWUh2zEJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5
	uZsYwQngmfQOxlUNFocYBTgYlXh4DYQ/BgmxJpYVV+YeYpTgYFYS4V3bBhTiTUmsrEotyo8v
	Ks1JLT7EmAwMgonMUqLJ+cDklFcSb2hsYmZkaWRuaGFkbE6asJI478FW60AhgfTEktTs1NSC
	1CKYLUwcnFINjEGpXDO5TO+9+zrb3tHN2XhlVWeA6+l8OY3U/knVAmsXLXSJ53tjYmmwbLtW
	6fKlOz2U36YZ7lVZqPeJefnHDMVE7vqTJdNddHzuqyUdF3wvcvyUNFvFjuTD344eX7icxzHJ
	RN3oiF/SrsXR5oF357pGaLhzBhfcLkifqHXb9/ChBdcaXZcbKbEUZyQaajEXFScCAJXJMHpE	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 09:18 PM, Krzysztof Kozlowski wrote:
> From: Chanwoo Choi <cw00.choi@samsung.com>
> 
> This patch use device name to make sysfs path according to device type:
> 
> max14577-muic
> - /sys/class/extcon/max14577-muic/
> max77836-muic
> - /sys/class/extcon/max77836-muic/
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---

Applied.

Thanks,
Chanwoo Choi

