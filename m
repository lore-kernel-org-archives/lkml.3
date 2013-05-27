Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3E0GIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 02:08:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64921 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab3E0GIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 02:08:16 -0400
X-AuditID: cbfee68e-b7f276d000002279-24-51a2f84e4602
Message-id: <51A2F84D.9030605@samsung.com>
Date: Mon, 27 May 2013 15:08:13 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: myungjoo.ham@samsung.com, balbi@ti.com, ldewangan@nvidia.com,
        gg@slimlogic.co.uk, lgirdwood@gmail.com, broonie@kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, gregkh@linuxfoundation.org,
        george.cherian@ti.com, sameo@linux.intel.com
Subject: Re: [PATCH v5 2/3] extcon: Palmas Extcon Driver
References: <1369405896-30246-1-git-send-email-kishon@ti.com>
 <1369405896-30246-3-git-send-email-kishon@ti.com>
 <51A2F07F.8070009@samsung.com> <51A2F512.2090907@ti.com>
In-reply-to: <51A2F512.2090907@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsWyRsSkWNfvx6JAgy0PZS0O3q+3mPrwCZvF
	gdkPWS1OHVzOatG/xcXiwJ8djBbNi9ezWVx42sNmsXTfahaLb1c6mCwWti1hsbi8aw6bxewl
	/SwWi5a1MlvcblzBZnF4xQEmi3Uvp7NYnO5mdRDyWPD5CrvHzll32T02repk83i1eiarx51r
	e9g85p0M9Ng/dw27x/kZCxk9epvfsXn0bVnF6DF1yl9Gj+M3tjN5fN4kF8AbxWWTkpqTWZZa
	pG+XwJUx/81J1oLjnBUHr75nb2D8zd7FyMkhIWAi8fJnFzOELSZx4d56ti5GLg4hgaWMEgvP
	HGSEKTrbeYwVIjGdUeLouifMEM4LRonpD16xgFTxCmhJTLiyCayDRUBV4uiCSWA2G1B8/4sb
	bCC2qECYxMrpV6DqBSV+TL4HZosA1Zze+QPsDGaB1cwSTZvDQGxhAQuJD1vOskAsW8Mo0T2x
	nQkkwSmgJrFq1UtGiAYdif2t09ggbHmJzWvegl0nIXCFQ2L5izOsEBcJSHybfAhoEgdQQlZi
	0wGonyUlDq64wTKBUWwWkptmIRk7C8nYBYzMqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzEC
	E8bpf8/6djDePGB9iDEZaOVEZinR5HxgwskriTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+OijdxfeDuz1n60TLRuMlilcmvhu9edXxNzjzxzLtrp
	sMfXXZFJxLB/RfbRS9IH1Dl2b3C88LdiX0S7ujpfg3sdL3NMlZSg6FLJVwEvk7b8Xr3mieV1
	sQau45I/g+e2t1+wY3o7bfd5uduTwreErJ5qw1Iy5dWvJTvdtDbcuSwrJpXUr/fN+rcSS3FG
	oqEWc1FxIgAcx+T0LgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsVy+t9jQV2/H4sCDW6vF7E4eL/eYurDJ2wW
	B2Y/ZLU4dXA5q0X/FheLA392MFo0L17PZnHhaQ+bxdJ9q1ksvl3pYLJY2LaExeLyrjlsFrOX
	9LNYLFrWymxxu3EFm8XhFQeYLNa9nM5icbqb1UHIY8HnK+weO2fdZffYtKqTzePV6pmsHneu
	7WHzmHcy0GP/3DXsHudnLGT06G1+x+bRt2UVo8fUKX8ZPY7f2M7k8XmTXABvVAOjTUZqYkpq
	kUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Qi0oKZYk5pUChgMTi
	YiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjPlvTrIWHOesOHj1PXsD42/2LkZODgkBE4mz
	ncdYIWwxiQv31rN1MXJxCAlMZ5Q4uu4JM4TzglFi+oNXLCBVvAJaEhOubGIEsVkEVCWOLpgE
	ZrMBxfe/uMEGYosKhEmsnH4Fql5Q4sfke2C2CFDN6Z0/mEFsZoHVzBJNm8NAbGEBC4kPW86y
	QCxbwyjRPbGdCSTBKaAmsWrVS0aIBh2J/a3T2CBseYnNa94yT2AUmIVkxywkZbOQlC1gZF7F
	KJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZyOnknvYFzVYHGIUYCDUYmHd8GMRYFCrIllxZW5
	hxglOJiVRHgTooFCvCmJlVWpRfnxRaU5qcWHGJOBQTCRWUo0OR+YKvNK4g2NTcyMLI3MDS2M
	jM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgVG8YaNWoH9ESwRT4oaoNu6Vr25k7bD0
	0ttpWJ72KUfy95pkpSt9rf7z+orvX1fW+zyvsm/5JpEc+bnTK74nvM3dtn3x/JsF/4xV9ovd
	DtO8WCH+W/Ly90eL+I/X353YczTjxs0Tp+c9WcfAp6V9/oqS3UfdTWvPbBYvybilxSq7Xyz4
	oe9MN1klluKMREMt5qLiRACeQ1KGiwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 02:54 PM, Kishon Vijay Abraham I wrote:
> Hi,
>
> On Monday 27 May 2013 11:04 AM, Chanwoo Choi wrote:
>> Hi Kishon,
>>
>> I have some comment about this patch
>> and upload modified patch to following repository (extcon-for-palmas).
>> - http://git.kernel.org/cgit/linux/kernel/git/chanwoo/extcon.git/commit/?h=extcon-for-palmas&id=f2b7cb80699cbe1a5fd6c97ef2c600915f8d7f2c
>>
>> This patchset include patch related to other module
>> ,so I need your opinion to apply this patchset to git repository.
>
> yeah.. Still there is some confusion with palmas_set_switch_smps10(). I think we can remove it for now and add it separately later. By this at least we can have device mode fully functional in OMAP5. What do you think?
>

 I agree your opinion.

But, I propose some fixes about palmas_set_switch_smps10().
I dont' prefer to call global function in exton-palmas.c from palmas-regulator.c.
So, Why don't you use regulator consumer instead of global function?
You can register specific regulator for enabling or disabling SMPS10_SWITCH_EN
and then control SMPS10_SWITCH_EN bit through regulator framework in extcon-palmas.c
without calling global function.

Thanks,
Chanwoo Choi

