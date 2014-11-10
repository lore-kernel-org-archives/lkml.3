Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaKJBK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:10:59 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:31777 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaKJBK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:10:57 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-f79b86d000004a5a-77-5460109e9837
Content-transfer-encoding: 8BIT
Message-id: <5460109E.9060603@samsung.com>
Date: Mon, 10 Nov 2014 10:10:54 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "sre@kernel.org" <sre@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "anton@enomsg.org" <anton@enomsg.org>, "pavel@ucw.cz" <pavel@ucw.cz>
Subject: Re: [PATCH 1/3] power: core: Add generic interface to get battery
 specification.
References: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
 <1412679518-21499-2-git-send-email-jonghwa3.lee@samsung.com>
 <20ADAB092842284E95860F279283C5642ED8AE04@BGSMSX104.gar.corp.intel.com>
In-reply-to: <20ADAB092842284E95860F279283C5642ED8AE04@BGSMSX104.gar.corp.intel.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsWyRsSkRHeeQEKIwacTJhYHt2paTHryntli
	4srJzBZrv/awW1zeNYfN4nPvEUaLu6eOslmc3l3iwOExof8To8fOWXfZPTav0PJYvOclk8em
	VZ1sHitWf2f3+LxJLoA9issmJTUnsyy1SN8ugStj3fRPLAWz2SpOrHvH3MDYz9rFyMkhIWAi
	sfT8GihbTOLCvfVsXYxcHEICSxkl9i3czwZT9OzjeRaIxCJGiT8vLoIleAUEJX5MvgeU4OBg
	FpCXOHIpGyTMLKAuMWneImaI+teMElunXWGGqNeSeHBqFjuIzSKgKrH7+BYwm01ATuJt0zdG
	EFtUIEzi6oTjLCC2iICKxNSW70wgg5gFjjNJfLr5DmyQsEC0xLEzu5kgNlxklPjZ9AfsB06g
	7mdzHoD9ICHwiF1i2upGJoh1AhLfJh8CO1VCQFZi0wFmiNckJQ6uuMEygVFsFpKHZiE8NAvJ
	QwsYmVcxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525iBEbk6X/PJu5gvH/A+hCjAAejEg+vw9v4
	ECHWxLLiytxDjKZAR0xklhJNzgfGfV5JvKGxmZGFqYmpsZG5pZmSOK+O9M9gIYH0xJLU7NTU
	gtSi+KLSnNTiQ4xMHJxSDYyz1nZa6JoyHNnyVf34Ponrv39vsJlkcl7RcOHn/ffioptMNhfH
	GTC+8Nl72eYCr9Cennf8+okv3rsdKszfWPvdsWfSBweXC49EEqW2bJ2U7Roen+M96bPNx8W+
	ehVfUlZGNTQIasw81mXIHXNmFc+qL0f/9Hkti15xfbnY/+9TVjLW6L7XXhWhxFKckWioxVxU
	nAgAL0YozsMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jAd15AgkhBrM/6lgc3KppMenJe2aL
	iSsnM1us/drDbnF51xw2i8+9Rxgt7p46ymZxeneJA4fHhP5PjB47Z91l99i8Qstj8Z6XTB6b
	VnWyeaxY/Z3d4/MmuQD2qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGeum
	f2IpmM1WcWLdO+YGxn7WLkZODgkBE4lnH8+zQNhiEhfurWfrYuTiEBJYxCjx58VFNpAEr4Cg
	xI/J94CKODiYBeQljlzKBgkzC6hLTJq3iBmi/jWjxNZpV5gh6rUkHpyaxQ5iswioSuw+vgXM
	ZhOQk3jb9I0RxBYVCJO4OuE42GIRARWJqS3fmUAGMQscZ5L4dPMd2CBhgWiJY2d2M0FsuMgo
	8bPpD9jZnEDdz+Y8YJvAKDALyYGzEA6cheTABYzMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNz
	NzGC4/2Z9A7GVQ0WhxgFOBiVeHgd3saHCLEmlhVX5h5ilOBgVhLhrf0PFOJNSaysSi3Kjy8q
	zUktPsRoCvTeRGYp0eR8YCrKK4k3NDYxM7I0Mje0MDI2VxLnPdhqHSgkkJ5YkpqdmlqQWgTT
	x8TBKdXAaK9wwj/ApX7x38wtYWo/o6PuBwksD3ji6Sg6aaKpi5ndw8SKQKa1n354BWvX/zC+
	y2g7dbfOaWWb7WcPrH5lz7vQ21Rb5vSGlypzZq/wEDlkFTzhyrHF5Xa1M2fe4F0Zxf7h+j+G
	cEXvMLO4nTtizCyV95wMNPj05qHn1x7miaW//9zOZpKZrsRSnJFoqMVcVJwIAIawm+MNAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 11월 08일 19:13, Tc, Jenny wrote:

>> +ATOMIC_NOTIFIER_HEAD(psy_battery_info_notifier);
> 
>  Isn't it good to reuse the existing power_supply_notifier for this?
> 
>> +enum battery_info_notifier_events {
>> +	PSY_BATT_INFO_REGISTERED,
>> +	PSY_BATT_INFO_UNREGISTERED,
>> +};
> 
> If we use the power_supply_notifier, then this can be moved to
> enum power_supply_notifier_events
> 


It doesn't use power_supply_notifier, rather than it uses newly introduced
notifier for battery information. Intention of making of new notifier block here
is to extinguish event from power_supply_changed which might be noisy for
battery information consumer. However, If it looks wasteful code, it's not a big
deal to use existed power_supply_notifier.

Thanks,
Jonghwa

