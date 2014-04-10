Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301AbaDJDtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:49:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11360 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965117AbaDJDts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:49:48 -0400
X-AuditID: cbfee68f-b7f156d00000276c-b7-534614da732a
Message-id: <534614DB.9000805@samsung.com>
Date: Thu, 10 Apr 2014 12:49:47 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: myungjoo.ham@samsung.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com
Subject: Re: [PATCH] extcon: palmas: explicitly set edev name as node name
References: <1395989462-14613-1-git-send-email-kishon@ti.com>
In-reply-to: <1395989462-14613-1-git-send-email-kishon@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkUPeWiFuwwbZXQhYH79dbNC9ez2Zx
	4WkPm8XlXXPYLG43rmBzYPXYP3cNu0ffllWMHsdvbGfy+LxJLoAlissmJTUnsyy1SN8ugStj
	3wHZgpWsFc+urWBrYJzD0sXIySEhYCKx9f8FdghbTOLCvfVsXYxcHEICSxklPn94xQhTtH1V
	MyNEYjqjxJ4bB5ghnNeMEkc3rWQFqeIV0JI4+aSXGcRmEVCVuNU0EyzOBhTf/+IGG4gtKhAm
	sXL6FRaIekGJH5PvgdkiQDWnd/4A62UWSJM4PPMlmC0s4CXxZ/dWsBohAVuJty0PweKcAnYS
	r1asY4So15HY3zqNDcKWl9i85i3YcRIC69gl1ry7wgRxkIDEt8mHgAZxACVkJTYdYIb4TFLi
	4IobLBMYxWYhOWkWkrGzkIxdwMi8ilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMwrk7/e9a/
	g/HuAetDjMlAKycyS4km5wPjMq8k3tDYzMjC1MTU2Mjc0ow0YSVx3vsPk4KEBNITS1KzU1ML
	Uovii0pzUosPMTJxcEo1MArs7BC8ePWIbl+3+6SaP8bixoqv/MorRX+XPP3NfrUxoy+oe5P8
	pPNFM1L10m87GXqfYtGQkTO/8orh6v5FWwUknjAyRYlrqqrd2CN39rirg8TrucZf3z+sPbg2
	SXVPWvis6UtlH+dJnjwaX9bwL3b9kVNT9KZps6af3/Ne9MfP7lmPzC/5f1JiKc5INNRiLipO
	BADs1g2RwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoO4tEbdgg7stPBYH79dbNC9ez2Zx
	4WkPm8XlXXPYLG43rmBzYPXYP3cNu0ffllWMHsdvbGfy+LxJLoAlqoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdor5JCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsIYxY98B2YKVrBXPrq1ga2Ccw9LFyMkhIWAisX1VMyOELSZx
	4d56ti5GLg4hgemMEntuHGCGcF4zShzdtJIVpIpXQEvi5JNeZhCbRUBV4lbTTLA4G1B8/4sb
	bCC2qECYxMrpV1gg6gUlfky+B2aLANWc3vkDrJdZIE3i8MyXYLawgJfEn91bwWqEBGwl3rY8
	BItzCthJvFqxjhGiXkdif+s0NghbXmLzmrfMExgFZiFZMQtJ2SwkZQsYmVcxiqYWJBcUJ6Xn
	GuoVJ+YWl+al6yXn525iBEftM6kdjCsbLA4xCnAwKvHwHljmGizEmlhWXJl7iFGCg1lJhFdB
	yC1YiDclsbIqtSg/vqg0J7X4EGMyMAQmMkuJJucDE0peSbyhsYmZkaWRuaGFkbE5acJK4rwH
	Wq0DhQTSE0tSs1NTC1KLYLYwcXBKNTBqm8r68x9f1Cr17VqBXbaH/OtwwVcRv1cpxCzO99C2
	PvrbXn3nSVXDkznN6YczVHM9lPS7q3R/MmjfPnza2Tb2s1bvXEnr2GOZ2x22TrSdIr1Y6lYV
	8+SQ5tmtfF86bfqX19bGmcmLa0U+Fs/4LZ11PzursPD+r5mNV7flszwwFXC6K9AnpsRSnJFo
	qMVcVJwIAG0h3PAeAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 03/28/2014 03:51 PM, Kishon Vijay Abraham I wrote:
> commit ca488 (extcon: of: Remove unnecessary function call by using the
> name of device_node) started using node name instead of device name
> to get the extcon device. This breaks dwc3-omap since it's not able to
> get the extcon device anymore. Fixed it by setting edev name of
> palmas to be the same as its node name.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Reported-by: Felipe Balbi <balbi@ti.com>
> ---

Applied this patch
but, you could check this patch on extcon-next branch
after few days. becuase I have firewall issue of kerner.org.

Thanks,
Chanwoo Choi



