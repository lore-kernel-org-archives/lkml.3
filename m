Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190AbaEGNhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:37:03 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40526 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaEGNg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:36:58 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-f7-536a36f7f241
Message-id: <536A36F5.5080303@samsung.com>
Date: Wed, 07 May 2014 15:36:53 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Rahul Sharma <rahul.sharma@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        sunil joshi <joshi@samsung.com>
Subject: Re: [PATCHv2 1/3] phy: Add exynos-simple-phy driver
References: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
 <1396967856-27470-2-git-send-email-t.stanislaws@samsung.com>
 <534506B1.4040908@samsung.com>
 <CAPdUM4M109_kzY6cUMJQPSwgazvWmNDWL1JeXgiqnzvH8dhK2Q@mail.gmail.com>
 <53451A60.4050803@samsung.com> <53675D72.70103@ti.com>
 <CAPdUM4N+2VXpiFSiWW9gKfbte1zkpDbCOSF+KvEo4T1KLqqwjw@mail.gmail.com>
In-reply-to: <CAPdUM4N+2VXpiFSiWW9gKfbte1zkpDbCOSF+KvEo4T1KLqqwjw@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t/xa7rfzbKCDbbtEre4te4cq8X8I0Di
	ytf3bBYH/uxgtPi+6wu7Re+Cq2wWF572sFmcbXrDbnF51xw2i54NW1ktZpzfx2QxZdFhVovW
	vUfYLQ6/aWd14PPYtKqTzePOtT1sHve7jzN59G1Zxehx/MZ2Jo/Pm+QC2KK4bFJSczLLUov0
	7RK4MjoWLWYrWMdV0b94HksD42SOLkZODgkBE4mOBV0sELaYxIV769m6GLk4hASWMko0fWtn
	B0kICXxmlHgxIwrE5hXQkpi3bw9jFyMHB4uAqsSviXIgYTagOceWfAYLiwpESDy+IARRLSjx
	Y/I9sPEiAqESK1dOZwYZzyxwmUVi+bwFTCAJYQEbiX2XT7NA7H3PJLHh3lQ2kASnQLBE79Tt
	zCA2s4COxP7WaWwQtrzE5jVvmScwCsxCsmQWkrJZSMoWMDKvYhRNLU0uKE5KzzXUK07MLS7N
	S9dLzs/dxAiJmi87GBcfszrEKMDBqMTD+yI6I1iINbGsuDL3EKMEB7OSCO87/axgId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYxT5jl9nhYacmtZx5on/deYd663Nubc7iSWEXE5eKXyqYOXTdcu
	Lzi2tn7NI/e6uBl+vxR++DvPVLvNvFlgsopVA88en+1Kxzk5PjrrbSvgyVxtuDBh9hwP72qZ
	o/NZpub+KJqyjU0s5HSgdLcnz6oXvFLX3wfNP53q8od7+p/jS/t/rXb3PuajxFKckWioxVxU
	nAgAkwg/4HgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 12:38 PM, Rahul Sharma wrote:
> On 5 May 2014 15:14, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>> Hi,
>>
>> On Wednesday 09 April 2014 03:31 PM, Sylwester Nawrocki wrote:
>>> Hi,
>>>
>>> On 09/04/14 11:12, Rahul Sharma wrote:
>>>> Idea looks good. How about keeping compatible which is independent
>>>> of SoC, something like "samsung,exynos-simple-phy" and provide Reg
>>>> and Bit through phy provider node. This way we can avoid SoC specific
>>>> hardcoding in phy driver and don't need to look into dt bindings for
>>>> each new SoC.
>>>
>>> I believe it is a not recommended approach.
>>
>> Why not? We should try to avoid hard coding in the driver code. Moreover by
>> avoiding hardcoding we can make it a generic driver for single bit PHYs.
>>
> 
> +1.
> 
> @Tomasz, any plans to consider this approach for simple phy driver?
> 
> Regards,
> Rahul Sharma.
> 

Hi Rahul,
Initially, I wanted to make a very generic driver and to add bit and
register (or its offset) attribute to the PHY node.
However, there was a very strong opposition from DT maintainers
to adding any bit related configuration to DT.
The current solution was designed to be a trade-off between
being generic and being accepted :).

Regards,
Tomasz Stanislawski



>> Cheers
>> Kishon
> 

