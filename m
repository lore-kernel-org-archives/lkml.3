Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaDQIEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:04:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49357 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaDQIEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:04:31 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-2e-534f8b0d1d2d
Message-id: <534F8B11.8090808@samsung.com>
Date: Thu, 17 Apr 2014 17:04:33 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv2 5/8] ARM: EXYNOS: Support secondary CPU boot of Exynos3250
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
 <1397527192-21988-6-git-send-email-cw00.choi@samsung.com>
 <534E9374.6010807@samsung.com>
In-reply-to: <534E9374.6010807@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42JZI2JSpMvX7R9ssOsts8XfScfYLSatO8Bk
	cXm/tsX8I+dYLT5/aGG36F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWvy984/N4tT1
	z0ChyS/ZLNbPeM1icWzGEkaLvTsnMzoIeqyZt4bRo6W5h83j969JjB5/V71g9rhzbQ+bx+Yl
	9R5XTjSxevRtWcXo8XmTXABnFJdNSmpOZllqkb5dAlfG3OaFjAUrOSuWrdzL1MB4hr2LkZND
	QsBEYu2yNkYIW0ziwr31bF2MXBxCAksZJf4v6WWDKdrzcDU7RGIRo8T9VZ2sEM5rRol/t3Yz
	g1TxCmhJXF27AWwUi4CqxMEX88BsNqD4/hc3wCaJCoRJrJx+hQWiXlDix+R7YLaIgIrE5VPT
	GUGGMgssYJY42rUHLCEsECDxZfs5sGaw1YvvOoHYnALaEgefbQD7gVlAR2J/6zQ2CFteYvOa
	t8wggyQE1nJI7FgygxXiIgGJb5MPAQ3lAErISmw6wAzxmqTEwRU3WCYwis1CctMsJGNnIRm7
	gJF5FaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZgAjj971nvDsbbB6wPMSYDrZzILCWanA9M
	IHkl8YbGZkYWpiamxkbmlmakCSuJ8yY9TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwCjg
	UxU1+dTyeemLjseFrHnx4Ej4yQshFXMW8txZqxw7ca772WCFwydsd5ntKN6WajfHIHUDl3fr
	TT/GGO7M3nPnbXN389lKcf63+qtjXJJzVXnmujNqMtcXPvJ7wT5vTWJQ9Z9+5XfPb+Rbis7+
	XSpgnHHpYP6Bz66pejf5sw/M0apJPeMyKVSJpTgj0VCLuag4EQBJjNn1FgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsVy+t9jAV3ebv9ggxMd5hZ/Jx1jt5i07gCT
	xeX92hbzj5xjtfj8oYXdonfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZ3L7Ma/H3zj82i1PX
	PwOFJr9ks1g/4zWLxbEZSxgt9u6czOgg6LFm3hpGj5bmHjaP378mMXr8XfWC2ePOtT1sHpuX
	1HtcOdHE6tG3ZRWjx+dNcgGcUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZK
	CnmJuam2Si4+AbpumTlArygplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsY
	M+Y2L2QsWMlZsWzlXqYGxjPsXYycHBICJhJ7Hq6GssUkLtxbz9bFyMUhJLCIUeL+qk5WCOc1
	o8S/W7uZQap4BbQkrq7dwAhiswioShx8MQ/MZgOK739xgw3EFhUIk1g5/QoLRL2gxI/J98Bs
	EQEVicunpjOCDGUWWMAscbRrD1hCWCBA4sv2c2DNYKsX33UCsTkFtCUOPtsAdh6zgI7E/tZp
	bBC2vMTmNW+ZJzAKzEKyYxaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4v
	z6R3MK5qsDjEKMDBqMTDy/nbL1iINbGsuDL3EKMEB7OSCG90rX+wEG9KYmVValF+fFFpTmrx
	IcZkYBBMZJYSTc4Hpr68knhDYxMzI0sjc0MLI2Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh
	4uCUamDcGtJRsPwUZ/dEyQWlX+2WiHpvljrH5C3Kn3fXTqnP32JfzOYY412XvT50MTz13Kgd
	yNzbUZewTOUaV35c1ZnAnw9Nw/vFt1evD1rwRfnLJm+ji+2ddU48k996uc5KzG59MvG409bJ
	nCau88Vm7Xq2+7yniOjFm1sX/C/61sIQcKTjb+PqC0lKLMUZiYZazEXFiQBWN7v/cwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 04/16/2014 11:28 PM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 15.04.2014 03:59, Chanwoo Choi wrote:
>> This patch fix the offset of CPU boot address and don't operate smc call
>> of SMC_CMD_CPU1BOOT command for Exynos3250.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>   arch/arm/mach-exynos/firmware.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
>> index aa01c42..6205d4f 100644
>> --- a/arch/arm/mach-exynos/firmware.c
>> +++ b/arch/arm/mach-exynos/firmware.c
>> @@ -30,13 +30,16 @@ static int exynos_do_idle(void)
>>
>>   static int exynos_cpu_boot(int cpu)
>>   {
>> +    if (soc_is_exynos3250()) {
>> +        return 0;
> 
> This is strange. How the firmware knows when to boot the CPU then, if CPU1BOOT command is not called?

As I knew, Exynos3250 doesn't need smc for secondary boot
because WFE in secure mode for Exynos3250 is removed.
So, Exynos3250 doesn't need to send IPI_WAKEUP after call_firmware_op(cpu_boot, ...).

Best Regards,
Chanwoo Choi

