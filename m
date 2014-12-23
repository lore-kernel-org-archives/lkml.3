Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaLWGf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 01:35:26 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12933 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaLWGfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 01:35:23 -0500
X-AuditID: cbfee68d-f79296d000004278-13-54990d289915
Message-id: <54990D28.2050205@samsung.com>
Date: Tue, 23 Dec 2014 15:35:20 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: myungjoo.ham@samsung.com, kgene.kim@samsung.com,
        Kyungmin Park <kyungmin.park@samsung.com>, rafael.j.wysocki@intel.com,
        Mark Rutland <mark.rutland@arm.com>, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, k.kozlowski@samsung.com, inki.dae@samsung.com,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCHv5 3/9] devfreq: event: Add exynos-ppmu devfreq-event driver
References: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
 <1419304697-14789-4-git-send-email-cw00.choi@samsung.com>
 <CAEUmHyYnb8_HNnuz8BLhMOh01+gpXfTv63P-ubYE1DK9uptonA@mail.gmail.com>
 <5498F0F4.7020700@samsung.com>
In-reply-to: <5498F0F4.7020700@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsWyRsSkUFeDd2aIwdwJZhaP1yxmsph/5Byr
	xaT7E1gsXr8wtOhdcJXN4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZLL1+kcniduMKNovH
	K96yW6za9YfR4mTHHEYHfo8189YweuycdZfdY/Gel0wem5fUe/RtWcXo8XmTXABbFJdNSmpO
	Zllqkb5dAlfGg21d7AWHeSueNH9gamC8wNXFyMkhIWAi8WrfK3YIW0ziwr31bCC2kMBSRonX
	02Rgau7taWfpYuQCii9ilPi/8z8zhPOaUWLDlFZmkCpeAS2J7luXWEBsFgFVidM/jjCB2GxA
	8f0vboBNFRUIk1g5/QoLRL2gxI/J94BsDg4RoJozH0VAZjILTGKRuDa7AaxeWMBfYvn5u6wQ
	y14ySnR0/wNbximgLbHt4xFWEJtZQF1i0rxFzBC2vMTmNW/BrpMQ6OWQWLt3AtRFAhLfJh8C
	2yYhICux6QAzxGuSEgdX3GCZwCg2C8lNs5CMnYVk7AJG5lWMoqkFyQXFSelFhnrFibnFpXnp
	esn5uZsYgfF8+t+z3h2Mtw9YH2IU4GBU4uFdcGZGiBBrYllxZe4hRlOgKyYyS4km5wOTRl5J
	vKGxmZGFqYmpsZG5pZmSOK+i1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwlsU7aCs0V
	9h/Zsy8HnjrjO7Wn9qHP9DtOtqGhX89OZgsIkzCaaXTIKOeRvWz1QxcX3v6Zmi9feH867e9r
	+/vzzYl7/1jP/XVP3ZR/PRvzagF2HpXZYvM0k5h7/R04j5xgE3TVbBR5ZrJaLYaf1SS8wq2X
	eeHn4zvr9k99ZCr3XmzjgkUropRYijMSDbWYi4oTAWQ/kCbiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jAV0N3pkhBg9n61o8XrOYyWL+kXOs
	FpPuT2CxeP3C0KJ3wVU2i7NNb9gtNj2+xmpxedccNovPvUcYLWac38dksfT6RSaL240r2Cwe
	r3jLbrFq1x9Gi5Mdcxgd+D3WzFvD6LFz1l12j8V7XjJ5bF5S79G3ZRWjx+dNcgFsUQ2MNhmp
	iSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAJysplCXmlAKF
	AhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYMx5s62IvOMxb8aT5A1MD4wWuLkZODgkB
	E4l7e9pZIGwxiQv31rN1MXJxCAksYpT4v/M/M4TzmlFiw5RWZpAqXgEtie5bl8A6WARUJU7/
	OMIEYrMBxfe/uMEGYosKhEmsnH6FBaJeUOLH5HtANgeHCFDNmY8iIDOZBSaxSFyb3QBWLyzg
	L7H8/F1WiGUvGSU6uv+BLeMU0JbY9vEIK4jNLKAuMWneImYIW15i85q3zBMYBWYh2TELSdks
	JGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSni2dSOxhXNlgcYhTgYFTi4V1wZkaI
	EGtiWXFl7iFGCQ5mJRFe9VagEG9KYmVValF+fFFpTmrxIUZTYBBMZJYSTc4HprK8knhDYxMz
	I0sjc0MLI2NzJXFeJfu2ECGB9MSS1OzU1ILUIpg+Jg5OqQbGA8t412r7KEt7lRd05nx0neZs
	5uuntKrSehVvipdlwN19x+X1dxx4If9RL0tq/6/1L4OMb72Ye8sh74uXjuDqRta6FxICpst/
	N6y++JL7Q9lS7X7ph9tObHfqrXu22tphwspKBzZL+QO5OnPNHn+zWeJ85bRlzszu5ivPbl7N
	eePzd3/Z8alcSizFGYmGWsxFxYkAfXTZ4S0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Varka,

On 12/23/2014 01:35 PM, Chanwoo Choi wrote:
> On 12/23/2014 12:40 PM, Varka Bhadram wrote:
>> On Tue, Dec 23, 2014 at 8:48 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>> This patch adds exynos-ppmu devfreq-event driver to get performance data
>>> of each IP for Samsung Exynos SoC. These event from Exynos PPMU provide
>>> useful information about the behavior of the SoC that you can use when
>>> analyzing system performance, and made visible and can be counted using
>>> logic in each IP.
>>>
>>> This patch is based on existing drivers/devfreq/exynos/exynos-ppmu.c
>>>
>>> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>

snip.

> 
>>
>>> +       }
>>> +
>>> +       data->clk_ppmu = devm_clk_get(dev, "ppmu");
>>> +       if (IS_ERR(data->clk_ppmu)) {
>>> +               data->clk_ppmu = NULL;
>>> +               dev_warn(dev, "failed to get PPMU clock\n");
>>> +       }
>> If PPMU clk get fails..?  return PTR_ERR(data->clk_ppmu)
> 
> If Exynos SoC don't register the clock to clock tree, the clock remains on state.
> So, I print just warning message.
> 
> But, It is not proper. I'll fix it.

I faced on unthinkable issue. I'm implementing missing PPMU clock of Exynos3250 (PPMUDMC0, PPMUDMC1, PPMUFSYS).
But, I can't find the parent clock of PPMUDMC0, PPMUDMC1 and the clock of PPMUFSYS on Exynos3250 datasheet.
Like this, some PPMU clocks is not specified on Exynos SoC datasheet because some clocks should be remained
with always-on state.

So, I want to show just warning message if exynos-ppmu driver fail to get ppmu clock.

Thanks,
Chanwoo Choi

