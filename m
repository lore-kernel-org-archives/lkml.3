Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaI2AkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:40:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:27769 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbaI2AkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:40:17 -0400
X-AuditID: cbfee68d-f79296d000004278-cc-5428aa6e7f57
Message-id: <5428AA6D.6010507@samsung.com>
Date: Mon, 29 Sep 2014 09:40:13 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv4 1/2] regulator: of: Add support for parsing
 regulator_state for suspend state
References: <1408343223-4043-1-git-send-email-cw00.choi@samsung.com>
 <1408343223-4043-2-git-send-email-cw00.choi@samsung.com>
 <20140904224948.GX29327@sirena.org.uk>
In-reply-to: <20140904224948.GX29327@sirena.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWyRsSkSDdvlUaIwal3mhZTHz5hs5h/5Byr
	xYE/OxgtXr8wtDjb9Ibd4tuVDiaLy7vmsFm07j3C7sDhsXPWXXaPTas62TzuXNvD5tG3ZRWj
	x+dNcgGsUVw2Kak5mWWpRfp2CVwZFy/MYC/YwVPx63wHawPja84uRk4OCQETiZOLlrFB2GIS
	F+6tB7K5OIQEljJKrF61i7mLkQOs6PZUAYj4dEaJNXdns0A4rxklOiecBuvmFdCSuDTzHBtI
	A4uAqsS7yf4gYTag8P4XN8BKRAXCJFZOv8ICUS4o8WPyPTBbREBZ4ur3vWAzmQW2MUpsPLYf
	LCEskCqx9eYlZohlKxglJjw/zQSS4BQwlvg//z8riM0soCOxv3UaG4QtL7F5zVuwBgmBa+wS
	X6ddYAdJsAgISHybfIgF4h1ZiU0HmCFelpQ4uOIGywRGsVlIjpqFZOwsJGMXMDKvYhRNLUgu
	KE5KLzLUK07MLS7NS9dLzs/dxAiMwNP/nvXuYLx9wPoQowAHoxIP74alGiFCrIllxZW5hxhN
	ga6YyCwlmpwPjPO8knhDYzMjC1MTU2Mjc0szJXFeRamfwUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoYJ1733z7pT7gGj/e9lF3btHIl1uXFTsnoCOS9WPBfq0pPpUb0VGFL3OEFcrY/hZVc
	N6z/kfbG88i/E8mP11w+zZ66/T27+PxNjQ++zLvQ+Z1v5a2tszijGiz/Bpz+nrnvZreLR4nl
	Kdm5CqfqSxyl9rozdj0PZD99eas3v1y/1OMbR0M0r75nVWIpzkg01GIuKk4EABuiasi7AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t9jQd28VRohBtt3KVlMffiEzWL+kXOs
	Fgf+7GC0eP3C0OJs0xt2i29XOpgsLu+aw2bRuvcIuwOHx85Zd9k9Nq3qZPO4c20Pm0ffllWM
	Hp83yQWwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6
	ZeYA3aKkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzLh4YQZ7wQ6eil/n
	O1gbGF9zdjFycEgImEjcnirQxcgJZIpJXLi3nq2LkYtDSGA6o8Sau7NZIJzXjBKdE06zgVTx
	CmhJXJp5jg2kmUVAVeLdZH+QMBtQeP+LG2AlogJhEiunX2GBKBeU+DH5HpgtIqAscfX7XrCZ
	zALbGCU2HtsPlhAWSJXYevMSM8SyFYwSE56fZgJJcAoYS/yf/58VxGYW0JHY3zqNDcKWl9i8
	5i3zBEaBWUiWzEJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwfH9THoH46oG
	i0OMAhyMSjy8HCs0QoRYE8uKK3MPMUpwMCuJ8Cq8Vg8R4k1JrKxKLcqPLyrNSS0+xGgKDIKJ
	zFKiyfnA1JNXEm9obGJmZGlkbmhhZGyuJM57sNU6UEggPbEkNTs1tSC1CKaPiYNTqoFR9+vt
	7/LqzwX+8SlUtR3Qfdqz0pKn8rVgk8f3aPdCza1ff6w/6bt9WfrnzKzNq5/41p1IflOwKWP6
	uggJvvBAzcaN606tU+NadqXH9fTrB0pSCh45reXLaxlW1c9l3c8+vevCyp9pbrKyz1aptv1u
	vlRWZP94Q+bayitX1bLz3CYmqxyTDd+jxFKckWioxVxUnAgAYXNwmAUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mark,

On 09/05/2014 07:49 AM, Mark Brown wrote:
> On Mon, Aug 18, 2014 at 03:27:02PM +0900, Chanwoo Choi wrote:
> 
>> +		suspend_uV = of_get_property(suspend_np, "regulator-volt",
>> +						NULL);
>> +		if (suspend_uV) {
>> +			suspend_state->uV = be32_to_cpu(*suspend_uV);
>> +
>> +			if (suspend_state->uV < constraints->min_uV)
>> +				suspend_state->uV = constraints->min_uV;
>> +			if (suspend_state->uV > constraints->max_uV)
>> +				suspend_state->uV = constraints->max_uV;
>> +		}
> 
> A few things here.  One is that this will fail if we don't have a
> voltage range specified at runtime.  It is possible that the user needs
> to override the voltage in suspend mode but not at runtime.  Perhaps we
> want to make them specify the runtime voltage anyway but if we do then
> the binding needs to say that this is mandatory even if it's just
> restating the hardware default.
> 
> It's also not clear to me that the suspend voltage needs to be in the
> range that we can vary at runtime, especially if we're not giving
> permission for runtime variation.  From that point of view we should
> probably just not check, but if we are going to check we should print a
> warning that we're doing it so people know that what they set in the DT
> isn't being followed.
> 

Firstly, I'm so sorry about late reply because of vacation.

I'll drop 'regulator-volt' property because of remaining with not clear state.

Next patchset (v5) will just include 'regulator-{on,off}-in-suspend'
without 'regulator-volt' property.

Best Regards,
Chanwoo Choi
