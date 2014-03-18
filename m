Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaCRGGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 02:06:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15903 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaCRGGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 02:06:03 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-cc-5327e2487319
Message-id: <5327E248.7040706@samsung.com>
Date: Tue, 18 Mar 2014 15:06:00 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: sre@ring0.de
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] power_supply: Add DT helper function to get
 power-supply dev from dt
References: <1395060227-23378-1-git-send-email-cw00.choi@samsung.com>
 <20140318003818.GA17391@earth.universe>
In-reply-to: <20140318003818.GA17391@earth.universe>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWyRsSkRNfjkXqwwZ4zZhaTnrxntpi4cjKz
	xdmmN+wWl3fNYbO43biCzWL5pwgHNo+ds+6ye2xeoeWx99APdo++LasYPT5vkgtgjeKySUnN
	ySxLLdK3S+DKOPXvPFvBcv6KT4/usTcwPuLpYuTkkBAwkdix7zk7hC0mceHeerYuRi4OIYGl
	jBLLdh9hhik6cHYGE0RiEaPE1pdvGCGcV4wS21b2sIJU8QpoSdz9fokFxGYRUJVoaZnBCGKz
	AcX3v7jBBmKLCoRJrJx+hQWiXlDix+R7YLaIgIDE18MXWUGGMgs0MUoc7J8P1iwskCxxeP9y
	JhBbSCBf4szMy2C3cgKdNOH5VbChzAI6Evtbp0HZ8hKb17xlBhkkIXCIXWLj+Z/MEBcJSHyb
	fAhoGwdQQlZi0wGo1yQlDq64wTKBUWwWkptmIRk7C8nYBYzMqxhFUwuSC4qT0osM9YoTc4tL
	89L1kvNzNzECo+30v2e9OxhvH7A+xJgMtHIis5Rocj4wWvNK4g2NzYwsTE1MjY3MLc1IE1YS
	5016mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgdFymtScBRdv72tbdP0Mn7bnOb9Vazun
	uAgrLqyRmfH8oFG69aIzUnc/Kl+5Y168w9Dn8tb/fxdcjJhxMmOtzwSvrCmbVF1fFq/QVHm7
	QoDr3/Fva1Yv6XaXXZ99cnLBthsN/qXsewrrg+2O6zPuqnvH9L/EIX6p/dE/3zh3mpVNqDGZ
	apCh0pqhxFKckWioxVxUnAgAJ4e6JMwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAV2PR+rBBt//6llMevKe2WLiysnM
	Fmeb3rBbXN41h83iduMKNovlnyIc2Dx2zrrL7rF5hZbH3kM/2D36tqxi9Pi8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8apf+fZCpbzV3x6dI+9gfERTxcjJ4eE
	gInEgbMzmCBsMYkL99azdTFycQgJLGKU2PryDSOE84pRYtvKHlaQKl4BLYm73y+xgNgsAqoS
	LS0zGEFsNqD4/hc32EBsUYEwiZXTr7BA1AtK/Jh8D8wWERCQ+Hr4IivIUGaBJkaJg/3zwZqF
	BZIlDu9fDnaGkEC+xJmZl9lBbE6g8yY8vwo2lFlAR2J/6zQoW15i85q3zBMYBWYh2TELSdks
	JGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTH8jOpHYwrGywOMQpwMCrx8L5gUw8W
	Yk0sK67MPcQowcGsJMK7dDJQiDclsbIqtSg/vqg0J7X4EGMyMAgmMkuJJucD00xeSbyhsYmZ
	kaWRuaGFkbE5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTBm7LJ2TlOdYb3p49HXTKu8
	/yacaz2TkaUmFx8wof86I5vX3TdWmdOjbap5+HwVvKexrNhp//nsnGd1epY8bc1KHXdNrgla
	F71qDnHZ+3z/62NC/0o/HLkQIdGcKhLQtNzU9mf/Mw5JEe4GZb1eYRXzrBSWI02KV4uv6X3c
	W13H7mw27fR2ZiWW4oxEQy3mouJEACUQQwspAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On 03/18/2014 09:38 AM, sre@ring0.de wrote:
> Hi,
> 
> On Mon, Mar 17, 2014 at 09:43:43PM +0900, Chanwoo Choi wrote:
>> This patchset add DT helper function to get power-supply device from devicetree.
>> - of_power_supply_get_dev(struct device *dev, enum power_supply_dev_type type,
>> 			  int index)
>> Power-supply class provides 'power_supply_get_by_name()' to users who want to
>> find power-supply device with the name of power-supply device.
>>
>> If CONFIG_OF is enabled, device drivers which want to get power-supply device
>> would directly get the power-supply device from devicetree by using of_power_
>> supply_get_dev(). This function can be used instead of power_supply_get_by_name().
>>
>> For example,
>> [...]
> 
> include/linux/power_supply.h provides the following function already:
> 
> struct power_supply *
> power_supply_get_by_phandle(struct device_node *np, const char *property);
> 

I checked power_supply_get_by_phandle().
But power_supply_get_by_phandle() is different from of_power_supply_get_dev()

So, I expalin the difference between "power_supply_get_by_phandle()" and "of_power_supply_get_dev()".

Existing "power_supply_get_by_phandle()"
- Need correct the name of power_supply property.
some device driver using power_supply_get_by_phandle() has the dependecy of 
the name of power_supply property.

If the name of power_supply property is modified,
have to modify some device driver using power_supply_get_by_phandle().

But,
Proposed "of_power_supply_get_dev()"
- of_power_supply_get_dev() has not dependency of specific name.
of_power_supply_get_dev() only need device type of power_supply device among following device type:
	"fuelgague"
	"charger"
	we can do addtional device type of power_supply device.

If some device driver use of_poewr_supply_get_dev(),
don't need to consider the name of power_supply device.	

Thanks,
Chanwoo Choi






