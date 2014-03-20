Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaCTEKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 00:10:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23715 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaCTEKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 00:10:15 -0400
X-AuditID: cbfee68f-b7f156d00000276c-9a-532a6a257ac0
Message-id: <532A6E1F.3040700@samsung.com>
Date: Thu, 20 Mar 2014 13:27:11 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 1/4] clk: samsung: add new Kconfig for Samsung common
 clock options
References: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
 <1394598781-3848-2-git-send-email-pankaj.dubey@samsung.com>
 <53298B63.40005@samsung.com>
In-reply-to: <53298B63.40005@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t8zQ13VLK1ggyWrjS02Pb7GanF51xw2
	ixnn9zFZrJ/xmsWBxWPzknqPvi2rGD0+b5ILYI7isklJzcksSy3St0vgytj/6g5bwSeuip0n
	l7A3MN7l6GLk5JAQMJFYvPwLM4QtJnHh3nq2LkYuDiGBZYwS359tY+li5AArWrvbGCK+iFHi
	2rk7UEWvGSV2vz7ACNLNK6Al0bVwDhuIzSKgKjHrwkQwm01AV+LJ+7lgG0QFwiQ2Te9jhagX
	lPgx+R4LiC0ioCJx+dR0sDnMAtkSR75sYQexhQViJBo2fWeEWLaEUWLN6h9MIAlOAU2JydNO
	sUM0WEusnLQNqlleYvOat8wgDRIC69gljpw+yw5xkYDEt8mHoN6Rldh0AOplSYmDK26wTGAU
	m4XkpllIxs5CMnYBI/MqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjJAo6t/BePeA9SHGZKCV
	E5mlRJPzgVGYVxJvaGxmZGFqYmpsZG5pRpqwkjjv/YdJQUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoYt62+3m21c+HOhfM9JJr7rltZ6W3vvrR39s3oXF8rz6cxMztN766R9gkXn33o0DqT
	vY+8xLadTKuROe0nenrb8TtbXMV+Kmm99u7ob/56uPBXHYf0b8PVBu2P7r1jVCjWZcvqUKiV
	vikrIO3Uxn/szdTz/y7NcP3LOjdu3gH+zqbmRXevqW6qU2Ipzkg01GIuKk4EAJOJCM24AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgK5qllawwa3t+habHl9jtbi8aw6b
	xYzz+5gs1s94zeLA4rF5Sb1H35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWbsf3WHreATV8XOk0vYGxjvcnQxcnBICJhIrN1t3MXICWSKSVy4t56ti5GL
	Q0hgEaPEtXN3oJzXjBK7Xx9gBKniFdCS6Fo4hw3EZhFQlZh1YSKYzSagK/Hk/VxmEFtUIExi
	0/Q+Voh6QYkfk++xgNgiAioSl09NB5vDLJAtceTLFnYQW1ggRqJh03dGiGVLGCXWrP7BBJLg
	FNCUmDztFDtEg7XEyknboJrlJTavecs8gVFgFpIds5CUzUJStoCReRWjaGpBckFxUnqukV5x
	Ym5xaV66XnJ+7iZGcIw+k97BuKrB4hCjAAejEg/vij2awUKsiWXFlbmHGCU4mJVEeK3dtYKF
	eFMSK6tSi/Lji0pzUosPMSYDg2Ais5Rocj4wfeSVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQ
	SCA9sSQ1OzW1ILUIZgsTB6dUA6PIwx0935dl9Hz4MtVTRbUhIMbmYdDps4KrDl6fG7dTY7Hw
	/JLegueiDyZ3Zs3b5XX/09zPfdzBSj0ys31rkhyy59qJx229arNvycJPMbv5zIVZy0vf6rye
	LvFviWp5wubcBQE+C5aXhK5ft7Vg4SIett0PV36O47i/bmseq8beIrU0n+8PZ9cqsRRnJBpq
	MRcVJwIAS9XFMRUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 09:19 PM, Tomasz Figa wrote:
> Hi Pankaj,
>
> On 12.03.2014 05:32, Pankaj Dubey wrote:
>> This patch adds new Kconfig file for adding new config option
>> as COMMON_CLK_SAMSUNG for Samsung common clock. This patch also
>> moves S3C24XX specific clock options here in this file.
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   drivers/clk/samsung/Kconfig |   11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>   create mode 100644 drivers/clk/samsung/Kconfig
>>
>> diff --git a/drivers/clk/samsung/Kconfig b/drivers/clk/samsung/Kconfig
>> new file mode 100644
>> index 0000000..26eb446
>> --- /dev/null
>> +++ b/drivers/clk/samsung/Kconfig
>> @@ -0,0 +1,11 @@
>> +config COMMON_CLK_SAMSUNG
>> +    bool
>> +    select COMMON_CLK
>> +
>> +config S3C2412_COMMON_CLK
>> +    bool
>> +    select COMMON_CLK_SAMSUNG
>> +
>> +config S3C2443_COMMON_CLK
>> +    bool
>> +    select COMMON_CLK_SAMSUNG
>>
>
> This patch adds S3C2412_COMMON_CLK and S3C2443_COMMON_CLK to 
> drivers/clk/samsung/Kconfig, but they are still present in 
> arch/arm/mach-s3c24xx/Kconfig, so after this patch there are duplicate 
> definitions.
>
> Best regards,
> Tomasz
>

OK, In that case I will club change in arm/mach-s3c24xx/Kconfig and 
clk/samsung/Kconfig together
  and resubmit once again.

-- 
Best Regards,
Pankaj Dubey

