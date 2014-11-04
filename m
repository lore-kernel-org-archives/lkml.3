Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaKDCQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:16:03 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:43822 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaKDCP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:15:57 -0500
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
X-AuditID: cbfee690-f79ab6d0000046f7-d5-545836dbb4c9
Content-transfer-encoding: 8BIT
Message-id: <545836DA.90905@samsung.com>
Date: Tue, 04 Nov 2014 11:15:54 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Addy Ke <addy.ke@rock-chips.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, tgih.jun@samsung.com,
        chris@printf.net, ulf.hansson@linaro.org, dinguyen@altera.com,
        olof@lixom.net, dianders@chromium.org, sonnyrao@chromium.org,
        huangtao@rock-chips.com, devicetree@vger.kernel.org, hl@rock-chips.com,
        linux-doc@vger.kernel.org, yzq@rock-chips.com, zyw@rock-chips.com,
        zhangqing@rock-chips.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kever.yang@rock-chips.com,
        lintao@rock-chips.com, linux-rockchip@lists.infradead.org,
        xjq@rock-chips.com, zhenfu.fang@rock-chips.com, chenfen@rock-chips.com,
        cf@rock-chips.com, hj@rock-chips.com,
        linux-arm-kernel@lists.infradead.org, zyf@rock-chips.com
Subject: Re: [PATCH v3] mmc: dw_mmc: add support for the other bit of sdio
 interrupt
References: <1414666240-16782-1-git-send-email-addy.ke@rock-chips.com>
 <1414977633-3196-1-git-send-email-addy.ke@rock-chips.com>
 <5457440E.3070002@samsung.com> <3540679.aQ4QUeBEJd@diego>
In-reply-to: <3540679.aQ4QUeBEJd@diego>
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHefeeczpao+NKfRMqWHfpZs31RBH17eCnosgR3ZadVPIyNjUr
	IilnKs2mVtIqdaZWMitmtJK8zYVlpq3l7CI2uohsFl1MJ1F25or69n/e3/99nucPD4tlbjqK
	TU7LELRp6hQ5E0pZZiq0y14rVdtWjg0QqJ0Yk4A+38vA0IWHNBhdNgQVjm4antS2MdDx7AqG
	M8NmGibe+mh44OulwH+rE8PtyjEM3d7rCO6UjTNw6fNusL5z02DOq6bA1XiJAcfEGQRfPRMY
	avqcEujs+8aAsayego/9ZRTomxxT4H3XBQSf3zgxdNTHQ0mlDC7fqGbgVfFL0T88hCH3xzsJ
	VHju4o1yXt9kZHhLuQXxF3OcFO8qMkj461dHGL7hWjRvrStg+H73fbGqPs4/f3iC5l94zRL+
	p6mF4otu1yHe5i7H/DfrnM3Td4Su3y+kJGcJ2hUb9oYm9VUs0XRz2QXnI3NQubQQhbCEU5CR
	3k9MUEeQpwM3RR3KyrgaRE76fzJ/Tc78QSoIqhBpNp6iA0DKhRF/6YAIWBZzc4nj2cHAM+aW
	khb9+T+NfIj4v9RKgv7FpPCyFwU0xS0g1Z1XJ/sw4gfbaMekJ5zbTux55ZN6Jqckr3rzcKAR
	5hoY0l46RgXADNGU2+r/M6EZkZaaIhwAIdwi4r3ZjAKAcO4Q0tVkmhIcx5HRUvvkqoSbTayt
	OBhtFmm79oIyogjTf4FM/wKZ/gtUiXAdChc0CRrdvkStYrlOnarLTEtcnpCeakXiuT3+NWi8
	iwZa19kRxyL5NKlqlmqbjFZn6Q6n2lGsuEQxjgpPSBcvNC1jT8xq5SqIVcSuXrVmrVIeKfVF
	jW+VcYnqDOGgIGgE7R5tZoqgsyMJGxKVg6Lbsw3pWeP89sal8efY+q+ViqqI1F+WnnvLsPmY
	wZM4EuY54FJF1Cn7PwwZFHk9R8JaTlukzqPzbTka1acDze3h6W7po9FdMe44xeD+5MZh8/yq
	BsemgpNns02HIs8tjM/cot/SNqr/3iGPc02V2+aN7PTlmjuTUtpLmoo9hvtySpekjonGWp36
	N4tjxnVpAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsVy+t9jAd3bZhEhBpNv81gs+/+dyaK14xWb
	xYuZJ1gtJlzezmgx/8g5Vouzyw6yWRy/tJjZov/NQlaL/49es1ocfX2VxeLHhlPMFlsWfGe2
	OPdqJaPFtuk/2SzmfIiz2PT4GqvFwrYlLBaXd81hszjyv5/R4tOD/8wWS69fZLI4df0zm8WE
	6WtZLN7emc5i0br3CLvFkzMzGS0+3L/IbHF8bbjFpAVCFnPXLWGzuDXxJlD9mxfMFi2/HzNZ
	zH+wg9lByaN17wQ2jzXz1jB6zG64yOJxua+XyWPl8i9sHptXaHlsWtXJ5nHn2h4gb0m9x5UT
	TaweN14tZPL4O2s/i0ffllWMHtuvzWP2+LxJLoA/qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzje
	Od7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwcYdkoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0
	fUOC4HqMDNBAwhrGjOvzNQvOCVR0ThNvYJzH28XIySEhYCJxseMZC4QtJnHh3nq2LkYuDiGB
	RYwS+ya0s4IkeAUEJX5MvgdUxMHBLCAvceRSNkiYWUBHYn/rNKj614wSPz4uY4Ko15DomvuK
	EcRmEVCVWHJqOdgcNqCG7d+Og9WICoRJHGqbB2aLCJhJ3LraxgwyiFlgM5vE4cnfwS4SBipq
	OfADasM+Ron9S/uYQRKcAuoSr9bvY5zAKDALyYGzEA6cheTABYzMqxhFUwuSC4qT0nON9IoT
	c4tL89L1kvNzNzGCU+cz6R2MqxosDjEKcDAq8fBGSkaECLEmlhVX5h5ilOBgVhLhnfU7PESI
	NyWxsiq1KD++qDQntfgQoynQexOZpUST84FpPa8k3tDYxMzI0sjc0MLI2FxJnPdgq3WgkEB6
	YklqdmpqQWoRTB8TB6dUA2PUBpmAH+9XnA9X4mO9vGrfmv5v/Zs53vKFSwd8i/j3aFniTOEf
	D7brrzy9IqKXa7q00eQ7902WTI6rnLh3stT8a1M9HrjNtNOZ9mPCpQ3XHd2svnY2X1ZJ4q3n
	X7U0+z6f+mHLi0v4il6p71gnvPTJU3MHz1mq4Qk/7/aHht3znDrjkDfT5YcsSizFGYmGWsxF
	xYkAVGvHJbMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Heiko.

On 11/03/2014 07:23 PM, Heiko Stübner wrote:
> Hi Jaehoon,
> 
> Am Montag, 3. November 2014, 17:59:58 schrieb Jaehoon Chung:
>> Hi, Addy.
>>
>> On 11/03/2014 10:20 AM, Addy Ke wrote:
>>> The bit of sdio interrupt is 16 in designware implementation,
>>> but it is 24 on Rockchip SoCs.This patch add sdio_id0 for the
>>> number of slot0 in the SDIO interrupt registers.
>>>
>>> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
>>> ---
>>> Changes in v2:
>>> - rebase on http://git.linaro.org/git/people/ulf.hansson/mmc.git, next
>>> branch Changes in v3:
>>> - Remove dts for sdio_id0, just replace this with 8, suggested by Doug
>>> - Change to support all Rockchip Socs, suggested by Heiko
>>>
>>>  drivers/mmc/host/dw_mmc-rockchip.c | 10 ++++++++++
>>>  drivers/mmc/host/dw_mmc.c          | 12 +++++++-----
>>>  drivers/mmc/host/dw_mmc.h          |  2 ++
>>>  include/linux/mmc/dw_mmc.h         |  3 +++
>>>  4 files changed, 22 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/mmc/host/dw_mmc-rockchip.c
>>> b/drivers/mmc/host/dw_mmc-rockchip.c index bbb4ec3..b997c8f 100644
>>> --- a/drivers/mmc/host/dw_mmc-rockchip.c
>>> +++ b/drivers/mmc/host/dw_mmc-rockchip.c
>>> @@ -68,14 +68,24 @@ static void dw_mci_rk3288_set_ios(struct dw_mci *host,
>>> struct mmc_ios *ios)> 
>>>  	}
>>>  
>>>  }
>>>
>>> +static int dw_mci_rockchip_parse_dt(struct dw_mci *host)
>>> +{
>>> +	/* It is slot 8 on Rockchip SoCs */
>>> +	host->sdio_id0 = 8;
>>> +
>>> +	return 0;
>>> +}
>>
>> Well, function is "__parse_dt__", but this function don't parse anything.
>> If All rockchip soc is supported, i think that it can be located to other
>> place.
> 
> do you have a suggestion for a location?
> 
> The only alternative I can see right now would be using the init-hook in 
> dw_mci_drv_data or adding a new field to it holding the slot-offset.
> [with using the init-hook being my personal preference of the two]

init-hook can be used, then, in future, it can also included other specific code for rock-chip.

Best Regards,
Jaehoon Chung
> 
> 
> Heiko
> 

