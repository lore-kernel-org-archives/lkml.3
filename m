Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbaLWIFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:05:06 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:64302 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbaLWIFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:05:04 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-47-5499221a4953
Message-id: <54992212.8050707@samsung.com>
Date: Tue, 23 Dec 2014 17:04:34 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        lgirdwood@gmail.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com
Subject: Re: [PATCH] regulator: rt5033-regulator: Use regulator_nodes/of_match
 in the descriptor
References: <1418901216-19030-1-git-send-email-beomho.seo@samsung.com>
 <20141222151025.GY17800@sirena.org.uk>
In-reply-to: <20141222151025.GY17800@sirena.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsWyRsSkUFdKaWaIwcL3VhZTHz5hs7j+5Tmr
	xaT7E1gsvl3pYLK4vGsOm8Xn3iOMFjMmv2RzYPfYOesuu8emVZ1sHn1bVjF6fN4kF8ASxWWT
	kpqTWZZapG+XwJUx/9oltoLbbBWLNrczNjBuZ+1i5OSQEDCROHzwLhOELSZx4d56ti5GLg4h
	gaWMEm9/7oYr+vn/LTtEYhGjRN/5tSwQzmtGiT0bdrKDVPEKaEkcf7OQGcRmEVCV2PdvAVg3
	m4CmxPspV1hAbFGBCIkPq76yQdQLSvyYfA8sLiKgLHH1+16wocwCMxglWnctBbtJWCBJ4tDN
	w2BFQgL5EvObn4Mt4xQwlmhYPA0ozgHUoCdx/6IWSJhZQF5i85q3zCBzJASOsUv8O3KIHeIg
	AYlvkw+B1UsIyEpsOsAM8ZmkxMEVN1gmMIrNQnLSLISps5BMXcDIvIpRNLUguaA4Kb3IRK84
	Mbe4NC9dLzk/dxMjMNpO/3s2YQfjvQPWhxgFOBiVeHgXnpkRIsSaWFZcmXuI0RToiInMUqLJ
	+cCYziuJNzQ2M7IwNTE1NjK3NFMS530t9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUAyNz
	k8/lKxEFR6b/E79599kLttivlufSP9/+EnN/0r/4sAcRnupHV6j2LdLrV7Rx3JapuFBjOYPq
	2hzDV+YrnNnfc21msU9YuHXZ2UJT2Yy78zt+OH3etfjJIauNyw1kZBd7rfvizT/lykTtBfzv
	tT9p9CmumqrSN22xEO/cfbusDNu+LdCc9zpJiaU4I9FQi7moOBEA254dEbECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t9jAV0ppZkhBj0rjC2mPnzCZnH9y3NW
	i0n3J7BYfLvSwWRxedccNovPvUcYLWZMfsnmwO6xc9Zddo9NqzrZPPq2rGL0+LxJLoAlqoHR
	JiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoBCWFssSc
	UqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxvxrl9gKbrNVLNrcztjAuJ21i5GT
	Q0LAROLn/7fsELaYxIV769m6GLk4hAQWMUr0nV/LAuG8ZpTYs2EnWBWvgJbE8TcLmUFsFgFV
	iX3/FoBNYhPQlHg/5QoLiC0qECHxYdVXNoh6QYkfk++BxUUElCWuft8LNpRZYAajROuupUwg
	CWGBJIlDNw+DFQkJ5EvMb34OtoxTwFiiYfE0oDgHUIOexP2LWiBhZgF5ic1r3jJPYBSYhWTF
	LISqWUiqFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQIjuVn0jsYVzVYHGIU4GBU4uFd
	cGZGiBBrYllxZe4hRgkOZiUR3pfiM0OEeFMSK6tSi/Lji0pzUosPMZoCA2Ais5Rocj4wzeSV
	xBsam5gZWRqZG1oYGZsrifMq2beFCAmkJ5akZqemFqQWwfQxcXBKNTAGnltyY2vgxm2yEStd
	Dh+Wit87L7P+7KzsrUEa1/Z5CbXl7eUw2/MzUTG32LrqQujS4vTt5nPUEmOPWuRsLV//typq
	flmco9a0qIBsebW791Tmtk642qbe8H+vWy0P73wnbQXrUuFltvl/5cMXWEf1HXG5IKXo1+fe
	Gyy/MqpNsLW3yUlGWImlOCPRUIu5qDgRALDZZ8L7AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2014 12:10 AM, Mark Brown wrote:
> On Thu, Dec 18, 2014 at 08:13:36PM +0900, Beomho Seo wrote:
>> This patch is add regulator_nodes/of_match in the regulator descriptor
>> for using information from DT instead of sppecific codes.
> 
>>  drivers/regulator/rt5033-regulator.c |    8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> This isn't replacing existing code with use of the framework, it's
> adding new bindings where there were none before so it needs to add a
> binding document too.
> 

Actually, RT5033 device tree binding document sent at mainling list already.
link is below,
http://marc.info/?l=linux-pm&m=141890859525642&w=2
It include regulator device node but above patch not applied yet.
If you want, I will revise dt binding document patch and send to mailing list.

Best regards,
Beomho Seo

