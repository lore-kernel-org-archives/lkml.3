Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaDWN3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:29:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40011 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbaDWN3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:10 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-19-5357c02481bc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>
Cc: "'Alessandro Zummo'" <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Haojian Zhuang'" <haojian.zhuang@linaro.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1398256168-493-1-git-send-email-k.kozlowski@samsung.com>
 <1398256168-493-2-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1398256168-493-2-git-send-email-k.kozlowski@samsung.com>
Subject: Re: [PATCH RESEND 2/2] rtc: 88pm860x: Add missing of_node_put
Date: Wed, 23 Apr 2014 22:29:08 +0900
Message-id: <000d01cf5ef8$01405f50$03c11df0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9e760E28GKN93WR4KOLcY0HOMB9QABZSLw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zI12VA+HBBt8WqlgsuXiV3WLO+jVs
	FpfPHWa0uLzwEqvF6xeGFpd3zWGz2N/ZwWhx8k8vowOHx56JJ9k87lzbw+ZxYsZvFo++LasY
	PabP+8nk8XmTXABbFJdNSmpOZllqkb5dAlfGwX7HgrVsFQcmtTE2ME5n7WLk5JAQMJFYe2gG
	M4QtJnHh3nq2LkYuDiGBZYwSRybuYIQp2j5pO1iRkMAiRonm+0oQRb8ZJeauvMQOkmATUJP4
	8uUwmC0iYCyxZuZSsEnMAtOYJFZcec4K0dHIKLGlvw+silPATeLh6S4mEFsYyF7/9jyYzSKg
	KvF65xGg1RwcvAK2Ek8OFoKEeQUEJX5MvscCYjMLaEms33mcCcKWl9i85i0zSLmEgLrEo7+6
	EDcYSXxbehOqRERi34t3UM/8ZZc4/IkVYpOAxLfJh1ggWmUlNh2ABoSkxMEVN1gmMErMQrJ4
	FpLFs5AsnoVkwwJGllWMoqkFyQXFSelFpnrFibnFpXnpesn5uZsYIdEMDNT7B6wPMSYDrZ/I
	LCWanA9MBnkl8YbGZkYWpiamxkbmlmakCSuJ86Y/SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjE
	wSnVwBh2IHn3yooDFwSK/L55rf4v+mDVoh3x1iKz7u9xC/d+lpH6Zynny3vcqpH7NFudbwgc
	3V/fe71cufND696eHzM6LxibmAruS/ldefXW8kimzyysiluWBmWoHFDZv+u3kslZ2ercX57m
	MRU8D7cVzDsfN8t149PbwhZv/n5w31Yzae4jq19HdtspsRRnJBpqMRcVJwIA5OUud/wCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jAV2VA+HBBntfy1ssuXiV3WLO+jVs
	FpfPHWa0uLzwEqvF6xeGFpd3zWGz2N/ZwWhx8k8vowOHx56JJ9k87lzbw+ZxYsZvFo++LasY
	PabP+8nk8XmTXABbVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqt
	kotPgK5bZg7QQUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjIP9jgVr
	2SoOTGpjbGCcztrFyMkhIWAisX3SdmYIW0ziwr31bCC2kMAiRonm+0pdjFxA9m9GibkrL7GD
	JNgE1CS+fDkMZosIGEusmbmUDaSIWWAak8SKK89ZIToaGSW29PeBVXEKuEk8PN3FBGILA9nr
	354Hs1kEVCVe7zzC2MXIwcErYCvx5GAhSJhXQFDix+R7LCA2s4CWxPqdx5kgbHmJzWveMoOU
	SwioSzz6qwtxg5HEt6U3oUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6Xn
	GukVJ+YWl+al6yXn525iBCeLZ9I7GFc1WBxiFOBgVOLhlVgeFizEmlhWXJl7iFGCg1lJhHfJ
	ovBgId6UxMqq1KL8+KLSnNTiQ4zJQH9OZJYSTc4HJrK8knhDYxMzI0sjMwsjE3Nz0oSVxHkP
	tloHCgmkJ5akZqemFqQWwWxh4uCUamBUFg70XjKhm2/p/ILY+Zsnz366wfJxoc4V/R9lKlsu
	KWQUyKn8Zk0JbJr45Vzj7KvZBz4l8G/6YSK5KXKCZe2mgBkX5d5b3S04d/PEagFlLQXNprep
	r89c7XhgpCX2TVX0aMHF1/NP9p546MN+zvOw5JJz1gZLJ1Zf8P9RLZG0gNHxTwt/8rv7SizF
	GYmGWsxFxYkAuE5ZAFoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 23, 2014 9:29 PM, Krzysztof Kozlowski wrote:
> 
> Add missing of_node_put to decrement the reference count.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/rtc/rtc-88pm860x.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
> index fb9e3c63b4ac..0c6add1a38dc 100644
> --- a/drivers/rtc/rtc-88pm860x.c
> +++ b/drivers/rtc/rtc-88pm860x.c
> @@ -301,6 +301,7 @@ static int pm860x_rtc_dt_init(struct platform_device *pdev,
>  	ret = of_property_read_u32(np, "marvell,88pm860x-vrtc", &info->vrtc);
>  	if (ret)
>  		info->vrtc = 0;
> +	of_node_put(np);
>  	return 0;
>  }
>  #else
> --
> 1.9.1

