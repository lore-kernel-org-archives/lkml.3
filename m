Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaDNGEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 02:04:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47616 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaDNGEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 02:04:46 -0400
X-AuditID: cbfee68f-b7f156d00000276c-c2-534b7a7cb1c6
Message-id: <534B7A80.3010509@samsung.com>
Date: Mon, 14 Apr 2014 15:04:48 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        t.figa@samsung.com, linux-samsung-soc@vger.kernel.org,
        hyunhee.kim@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, yj44.cho@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH 03/27] ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
 <1397122124-15690-4-git-send-email-cw00.choi@samsung.com>
 <4996376.GgWd9rnCP3@wuerfel>
In-reply-to: <4996376.GgWd9rnCP3@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkQLe2yjvYYP42Jou/k46xW3z+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2Rx8k8vo8WMyS/ZLNbPeM1isXfnZEYH
	Ho/fvyYxety5tofNY/OSeo++LasYPT5vkgtgjeKySUnNySxLLdK3S+DK2HJlIWvBdraKqXu+
	MDYwLmHtYuTkkBAwkXj/7gojhC0mceHeerYuRi4OIYGljBJrJ3+EK/q7Yz0LRGIRo8TyaaeZ
	IJzXjBJ3Px5iBqniFdCSWHrmE9goFgFViQ3dq8FsNqD4/hc32EBsUYEwiZXTr7BA1AtK/Jh8
	D8wWEVCUmPriGTPIUGaBPUwSl7u/gSWEBXwk7l49yw6xbQGjxPaJz8AmcQpoSky/uAJsA7OA
	jsT+1mlsELa8xOY1b8EmSQj8ZJe4dKeVGeIkAYlvkw8BTeUASshKbDrADPGbpMTBFTdYJjCK
	zUJy1CwkY2chGbuAkXkVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRmC0nv73rH8H490D1ocY
	k4FWTmSWEk3OB0Z7Xkm8obGZkYWpiamxkbmlGWnCSuK89x8mBQkJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgXP/lmFL1oTPlmu+mt8yOWLwqv3ureWqJ79+LJdE6Zzk0lvOEKkUq5H+vm6M0
	65bgH+Z/OcFvju+7GqPtwHTW18XvwIyt2dKf8xQOfHgyU2Lx26dJnqfWX2buD7mQsjm5im35
	NIcuoZ3i/GZt9Vvf2RnPZeSQPlZy+3OG0rObZU92POE6UB6bpMRSnJFoqMVcVJwIAIZst+Xs	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAd2aKu9gg9fzzS3+TjrGbvH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFyT+9jBYzJr9ks1g/4zWLxd6dkxkd
	eDx+/5rE6HHn2h42j81L6j36tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne
	1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6D4lhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4h
	QXA9RgZoIGENY8aWKwtZC7azVUzd84WxgXEJaxcjJ4eEgInE3x3rWSBsMYkL99azdTFycQgJ
	LGKUWD7tNBOE85pR4u7HQ8wgVbwCWhJLz3xiBLFZBFQlNnSvBrPZgOL7X9xgA7FFBcIkVk6/
	wgJRLyjxY/I9MFtEQFFi6otnzCBDmQX2MElc7v4GlhAW8JG4e/UsO8S2BYwS2yc+A5vEKaAp
	Mf3iCrANzAI6Evtbp7FB2PISm9e8ZZ7AKDALyZJZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgx
	t7g0L10vOT93EyM4FTyT3sG4qsHiEKMAB6MSD2/Cds9gIdbEsuLK3EOMEhzMSiK82zK8goV4
	UxIrq1KL8uOLSnNSiw8xJgPDYCKzlGhyPjBN5ZXEGxqbmBlZGpkbWhgZm5MmrCTOe7DVOlBI
	ID2xJDU7NbUgtQhmCxMHp1QDYzWbjcmxozUVGZn+v9+4KtUeV5m89x3HIUOflJ1TbQpdHv3a
	fvOhrOzxr/P4FjiohU+v+bJzpYKjYeqDhsSDzreT2bXLmkLXbDu3+IHlHLmzekYZJXa+x0s2
	ndl4sWnz65Spq47GlUSWMjluU82+vrieT81vj/iUNTtX753575hm+e67n7l2zlNiKc5INNRi
	LipOBACGR+VDSQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnd and Kukjin,

On 04/10/2014 06:46 PM, Arnd Bergmann wrote:
> On Thursday 10 April 2014 18:28:20 Chanwoo Choi wrote:
>> This patch add memory mapping for PMU (Power Management Unit) which is used
>> for power control of Exynos3250.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Same thing as for the SRAM here, can you work on making this a proper
> driver instead?
> 

As Chanho Park said, Sachin already submitted the DT support[1] for SYSRAM area.
[1] : http://www.spinics.net/lists/linux-samsung-soc/msg27647.html

But, this patch has not yet to merge git repository(linux-samsung.git, arm-soc.git).
So, I'll make a driver to handle PMU memory mapping after Sachin's patch is merged.

Best Regards,
Chanwoo Choi
