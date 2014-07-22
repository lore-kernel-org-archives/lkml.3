Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaGVFMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:12:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51925 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaGVFMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:12:42 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-c8-53cdf2c71e01
Message-id: <53CDF2C7.3070705@samsung.com>
Date: Tue, 22 Jul 2014 14:12:39 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: arizona: Get MICVDD against extcon device
References: <1405684740-28768-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1405684740-28768-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkUPf4p7PBBpueWVj8m3KD3eLyrjls
	FrcbV7BZLH/7n82BxePlxN9sHn1bVjF6fN4kF8AcxWWTkpqTWZZapG+XwJWx/OtBpoL5HBX7
	D+5hbmC8ytbFyMkhIWAiseF3ByOELSZx4d56oDgXh5DAUkaJ/efXAyU4wIqeP9YDqRESmM4o
	cXu+DkTNa0aJxeefsIMkeAW0JBZcuQJmswioShw9sIcJxGYDiu9/cQNsmahAmMTK6VdYIOoF
	JX5MvgdmiwhYSExZcosZxGYWSJSYc+4L2BxhATeJNf23mSAWh0qsebcD7FBOoDndL/sYIep1
	JPa3TmODsOUlNq95ywxynITAMnaJVbt3M0McJCDxbfIhFohnZCU2HWCGeFhS4uCKGywTGMVm
	ITlpFpKxs5CMXcDIvIpRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjMIZO/3vWu4Px9gHrQ4zJ
	QCsnMkuJJucDYzCvJN7Q2MzIwtTE1NjI3NKMNGElcd6kh0lBQgLpiSWp2ampBalF8UWlOanF
	hxiZODilGhjPLmyUfvAx6qRnz/J7nMJbZFpjjRnWlEQLP6zet3FhiHj/Lo+gNB62hi9JNxe+
	rDy6Nb905gq3fJVMz8Bdf4zn8Lidkkuc+kxJ9Zli41Mvj4NPtEpnZE+Svu+ZuO16o/HWb0Vl
	eSFqCcxc37M2+m/m3pzTbnLEVCTB+vy3J4FqHNEpPiejjyixFGckGmoxFxUnAgAXN4CKtwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jQd3jn84GG3x6aWjxb8oNdovLu+aw
	WdxuXMFmsfztfzYHFo+XE3+zefRtWcXo8XmTXABzVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8
	c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QOiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6
	viFBcD1GBmggYQ1jxvKvB5kK5nNU7D+4h7mB8SpbFyMHh4SAicTzx3pdjJxAppjEhXvr2UBs
	IYHpjBK35+t0MXIB2a8ZJRaff8IOkuAV0JJYcOUKmM0ioCpx9MAeJhCbDSi+/8UNsGZRgTCJ
	ldOvsEDUC0r8mHwPzBYRsJCYsuQWM4jNLJAoMefcF7A5wgJuEmv6bzNBLA6VWPNuByOIzQk0
	p/tlHyNEvY7E/tZpbBC2vMTmNW+ZJzAKzEKyYhaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswt
	Ls1L10vOz93ECI7QZ1I7GFc2WBxiFOBgVOLhnaB4NliINbGsuDL3EKMEB7OSCG/7HqAQb0pi
	ZVVqUX58UWlOavEhRlNgCExklhJNzgcmj7ySeENjEzMjSyNzQwsjY3Mlcd4DrdaBQgLpiSWp
	2ampBalFMH1MHJxSDYxOfIWrru7lYHj9c4YPx41d6iUqSWkPVlk5XZwz16VhTtLugP8BdsuF
	/687zS7954tKxsktd44UZWsc2i06SUD1QLTuwvope6wYZB7Ybdz9kuGJ5hZnMx6peoX/Zv/u
	zoyufFmX8ZNzyTSLVbNKM6ue+gf4Hgl9/yp/V+D/lbzXy4VXGPO1TXNXYinOSDTUYi4qTgQA
	bRu2EOYCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 08:59 PM, Charles Keepax wrote:
> Previously we would do a regulator get against the main Arizona device
> to obtain the MICVDD regulator. Arizona is an MFD device and normally
> MICVDD will be supplied by one of its children (the arizona-micsupp
> regulator). As devres destruction for the MFD device will run after all
> its children have been destroyed, the regulator will be destroyed before
> devres calls regulator_put. This causes a warning from both the
> destruction of the child node, as the regulator is still open, and from
> the put of the regulator as the regulator device has already been
> destroyed.
> 
> A simple fix here is to get the regulator against the extcon device
> itself such that devres runs when the child is destroyed. This has the
> additional benefit that if for some reason the extcon driver is unloaded
> the regulator reference won't hang around until the MFD is unloaded.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Applied now, Thanks.

Chanwoo Choi

