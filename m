Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110Ab3HSId4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:33:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59422 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3HSIdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:33:53 -0400
X-AuditID: cbfee691-b7fef6d000002d62-aa-5211d86b4b7d
Message-id: <5211D86B.9020700@samsung.com>
Date: Mon, 19 Aug 2013 17:33:47 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, bcousson@baylibre.com,
        tony@atomide.com, myungjoo.ham@samsung.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, ian.campbell@citrix.com,
        rob@landley.net, george.cherian@ti.com, gregkh@linuxfoundation.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH v2] extcon: palmas: Modified the compatible type to
 *ti,palmas-usb-vid*
References: <1376648448-27447-1-git-send-email-kishon@ti.com>
 <520EA5D6.3040409@wwwdotorg.org> <5211A7B3.4040906@ti.com>
In-reply-to: <5211A7B3.4040906@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsWyRsSkQDf7hmCQQcN2bYuD9+st7sz/y2ox
	/8g5VotTB5ezWjQvXs9m8aa3g8XiwtMeNotNj6+xWixsW8JicXnXHDaL2Uv6WSxuX+a1WHr9
	IpPF7cYVbBYTpq9lsTi84gCTxbqX01ksXh1sY7HYf8XLQdhjzbw1jB4tzT1sHt++TmLxeH+j
	ld1jwecr7B6vJ09g9Hi1eiarx/65a9g9Ni+p9+jbsorR4/iN7UwenzfJeWycGxrAG8Vlk5Ka
	k1mWWqRvl8CV0Tp9HlPBMfaKh5+MGxgns3UxcnJICJhInJp1G8oWk7hwbz2QzcUhJLCUUWLu
	yRZ2mKK7J7axQCSmM0r827+OGcJ5xSjx92I3M0gVr4CWxNQXmxlBbBYBVYm7na/BxrIBxfe/
	uAFmiwqESaycfoUFol5Q4sfke2C2CFDN6Z0/wIYyC1xjlui8uxqsQVggVuJCz1OwoUICVRIN
	c9aCncQpoCbRt2IWWDOzgI7E/tZpbBC2vMTmNW/BBkkIXOGQuLrlKwvERQIS3yYfArI5gBKy
	EpsOMEO8JilxcMUNlgmMYrOQ3DQLydhZSMYuYGRexSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7
	iRGYNk7/ezZxB+P9A9aHGJOBVk5klhJNzgemnbySeENjMyMLUxNTYyNzSzPShJXEedVbrAOF
	BNITS1KzU1MLUovii0pzUosPMTJxcEo1MAZWqztLPpuz8slD8/yAPeWBrLyh9gUXJ5YfjF3u
	bX7Nl2Ft1Oltdnm/010KPn4z/LM/NUn4XMbReTznAxfFZ00+sf58k8ah6J0FrjuenCs63DL5
	gV5IaOGNhce6C+93Fs9Um67R+/OzeLQL08xcJcPtpV6v35rwlpx/8Cuufor0jluONr1LDZVY
	ijMSDbWYi4oTAetfADkxAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsVy+t9jQd3sG4JBBr+2KFkcvF9vcWf+X1aL
	+UfOsVqcOric1aJ58Xo2ize9HSwWF572sFlsenyN1WJh2xIWi8u75rBZzF7Sz2Jx+zKvxdLr
	F5ksbjeuYLOYMH0ti8XhFQeYLNa9nM5i8epgG4vF/iteDsIea+atYfRoae5h8/j2dRKLx/sb
	reweCz5fYfd4PXkCo8er1TNZPfbPXcPusXlJvUffllWMHsdvbGfy+LxJzmPj3NAA3qgGRpuM
	1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDeVFMoSc0qB
	QgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBmt0+cxFRxjr3j4ybiBcTJbFyMnh4SA
	icTdE9tYIGwxiQv31gPFuTiEBKYzSvzbv44ZwnnFKPH3YjczSBWvgJbE1BebGUFsFgFVibud
	r8EmsQHF97+4AWaLCoRJrJx+hQWiXlDix+R7YLYIUM3pnT/AhjILXGOW6Ly7GqxBWCBW4kLP
	U7ChQgJVEg1z1rKD2JwCahJ9K2aBNTML6Ejsb53GBmHLS2xe85Z5AqPALCQ7ZiEpm4WkbAEj
	8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4KT0THoH46oGi0OMAhyMSjy8Fm6CQUKsiWXF
	lbmHGCU4mJVEeFnUgEK8KYmVValF+fFFpTmpxYcYk4FBMJFZSjQ5H5gw80riDY1NzIwsjcwN
	LYyMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBsfCazm3xY59mu2zZmZIRGNP9Y+aS
	+S0bMyXmHFy9jJHxUfT5b1nCqjNMlibMff6k4GT27iXrKzT4a5sYeMznzixdduFz99PKra2J
	WuuP+jzSkdt2IGNLx2dnvQittpWq+juO8zuXbL4albH5v9emmIUZvyQlSqy89CRsxHYfivG/
	wjw/YM4MfyWW4oxEQy3mouJEABURNK6OAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 02:05 PM, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Saturday 17 August 2013 03:51 AM, Stephen Warren wrote:
>> On 08/16/2013 04:20 AM, Kishon Vijay Abraham I wrote:
>>> The Palmas device contains only a USB VID detector, so modified the
>>> compatible type to *ti,palmas-usb-vid*.
>>
>>> diff --git a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
>>
>>>  PALMAS USB COMPARATOR
>>>  Required Properties:
>>> - - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb"
>>> + - compatible : Should be "ti,palmas-usb-vid".
>>
>> Has the old value been published in a release kernel? If so, it makes
> 
> No. This was merged only in 3.11-rc1. So I think we should take this version?
> Chanwoo can you take this patch?
> 

This patch will be included in 3.12-rc* after 3.12-rc1.
and this patch is applied on extcon-linus branch.

Thanks,
Chanwoo Choi

