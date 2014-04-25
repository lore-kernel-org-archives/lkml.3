Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaDYNUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:20:03 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32069 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaDYNT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:19:57 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-54-535a60fbfe30
Message-id: <535A60FF.4000806@samsung.com>
Date: Fri, 25 Apr 2014 15:19:59 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v2 01/13] Documentation: add extcon devicetree bindings
References: <20140422195117.GG12304@sirena.org.uk>
In-reply-to: <20140422195117.GG12304@sirena.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA03Sa0iTURjAcc/e9z2b5uh1Xjj4IWFRlJi6EjqmhR8qTgQRSFQD06lLBaey
	pWZFaaLhdV4ybXm/O2eSN9S8a3bRZCEqlZfMic1SpyiaSsVcH/z2Ow9/zvPl4VECPW3PCwm7
	I5WHSUKF0IIe+vN27MSOn9jbdUEDseaHF+5tPo57Zx7hnFkdxBPrCwzO0q1QuGhghMGZNdkU
	Vv4qYbCy6Tzu2W0FOL6sHuKRxRqAkz7qKKydT4W4oquWxjMbbwAuSSyn8Wh7PsQvypU0Lq1M
	oLCuZJiD6wamuLhi4hMHf42rhrhq6S/EGbl1NH6pz6VxQucAF3dpdxlcn/eT9nIgmkINIKPp
	aRzS3pbPkAzlGiBtqikuqalah6R/o4QmjdWOpEGdBMli7XOGTI53QNJdoOGStPhlSPSZO5C0
	bcZySXqTGly1Flt4BkpDQ6KkcpdzfhbBk4tfmIgWm7upr7UwFrxjk4E5D7FuqDn9G2WyHdJO
	18NkYMETsBUA5Q92UqbHKkDzpdtcY8VnHVFPWhFjNM0eQTvxlXtzyDqhps0MYLQtewNNx/Uz
	pt4KbWVP00bbsIfR2Gbnnil2hkFbizKjrdnLaCTVsDcXsCfRsLZ3709z9hTKN6z8751Qd8Iz
	aLIDatQsURmAVe1bodqXqfZlxYBSA1tpZECEwj9IJnJWSGSKyLAg54BwWQMwncd6KygbPNMH
	WB4QWvINR296CxhJlCJG1gcQjxLa8A1XxN4CfqAk5p5UHu4rjwyVKvoAh2duHwtc0tb9r11y
	F50ViseV0sAC3wW7Os/H6qjcQ+02vw+mOJJl99mYpmLR2taDQavPBzhDmcOJ4mNyXiFd/qGh
	Rf3K7qLzk8JbetGF+2FZfdm66y7NKXOSED50VT31MXsY35E0l7P6XRKtdzP3sXSNlud1mQWf
	nlGU1wTf1m1bvvfwENKKYInIkZIrJP8AdfaVi/wCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 09:51 PM, Mark Brown wrote:
> On Mon, Apr 14, 2014 at 01:46:12PM +0200, Robert Baldyga wrote:
> 
> That's quite some CC list you've got there, and the mail seems a bit
> corrupted too (it confused my MUA).
> 
>> This patch adds extcon devicetree bindings. Documentation describes in general
>> client and provider bindings, and contains detailed desctiprion of bindings
>> for each extcon provider.
>>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>> ---
>>  .../devicetree/bindings/extcon/extcon-adc-jack.txt |   60 +++++++++++++++++++
>>  .../devicetree/bindings/extcon/extcon-arizona.txt  |   47 +++++++++++++++
>>  .../devicetree/bindings/extcon/extcon-bindings.txt |   36 +++++++++++
>>  .../devicetree/bindings/extcon/extcon-gpio.txt     |   63 ++++++++++++++++++++
>>  .../devicetree/bindings/extcon/extcon-max14577.txt |   49 +++++++++++++++
>>  .../devicetree/bindings/extcon/extcon-max77693.txt |   56 +++++++++++++++++
>>  .../devicetree/bindings/extcon/extcon-max8997.txt  |   49 +++++++++++++++
>>  .../devicetree/bindings/extcon/extcon-palmas.txt   |   37 ++++++++++--
> 
> This is creating device tree bindings for MFD components as devices when
> those MFD components aren't well isolated from the rest of the device.
> If we need to add extcon bindings the device should have the flexibility
> to decide where to add the properties, and really things should be set
> up so there's less duplication in the documentation.

Those components has their own addresses on i2c bus, so they are,
technically, separate devices, and they can (should?) be described by
separate nodes. And I think it doesn't matter if they are grouped in one
chip.

However, it's easy to change it (give mfd master driver node to extcon),
and we can have extcon device defined without additional node, and then
parent node is an extcon node.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

> 
>> +The following is the list of cables detected by the controller. Each
>> +cable is assigned an identifier and client nodes use this identifies
>> +to specify the cable which they are interested in.
>> +
>> +  Cable			ID
>> +  ----------------------------
>> +
>> +  Mechanical	0
>> +  Microphone	1
>> +  Headphone		2
>> +  Line-out		3
>> +
>> +Example 1: An example of a extcon controller node is listed below.
>> +
>> +	extcon: arizona-extcon {
> 
> The above doesn't entirely reflect what the hardware is capable of doing
> - it reflects the default software configuration for the device but it's
> got a wider feature set.
> 


