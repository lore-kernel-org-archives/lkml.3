Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbaJXLxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:53:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61881 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbaJXLx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:53:28 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-a6-544a3db6d6ef
Message-id: <544A3DB6.8070804@samsung.com>
Date: Fri, 24 Oct 2014 20:53:26 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        geunsik.lim@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 2/3] ARM: dts: Add sleep mode pin configuration for
 exynos3250-rinato
References: <1414150795-31105-1-git-send-email-cw00.choi@samsung.com>
 <1414150795-31105-3-git-send-email-cw00.choi@samsung.com>
 <544A3C96.9080007@gmail.com>
In-reply-to: <544A3C96.9080007@gmail.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsWyRsSkRHebrVeIwZRFyhZ/Jx1jt/gzoZXN
	YtL9CSwWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8li6fWLTBanrn8Gcie/ZLNYtesPowOP
	x5p5axg9fv+axOixc9Zddo/NS+o9rpxoYvXo27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujFff
	bzEXvGKp2PImq4HxA3MXIweHhICJxLxO2S5GTiBTTOLCvfVsXYxcHEICSxklPt5+yAiRMJFY
	1vGcGSKxiFFi7v5dUFWvGSXOvz3ODlLFK6Al8f5hLwuIzSKgKjFp/lxmEJsNKL7/xQ02EFtU
	IExi5fQrLBD1ghI/Jt8Ds0UE1CW+TelnBxnKLDCXSeLy9QZWkISwQKzEnt9LmCC2LWCU+PTy
	LdgkTgFNiY17bzCC/MAsoCdx/6IWSJhZQF5i85q3YKdKCDRySDSd72GFuEhA4tvkQywQP8tK
	bDrADPGapMTBFTdYJjCKzUJy0yyEqbOQTF3AyLyKUTS1ILmgOCm9yESvODG3uDQvXS85P3cT
	IzByT/97NmEH470D1ocYBTgYlXh4DWZ7hgixJpYVV+YeYjQFOmIis5Rocj4wPeSVxBsamxlZ
	mJqYGhuZW5opifO+lvoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGxd4Neo1ZkqUV2qR7j
	IQvXd9aml//EL/0ku+d0/Fx2K+lLmSk/jKatuL7PSJOV06Pjaen1v1oHl9xZUPf56d176men
	d0lU+946w+gkqnVkQ8GiwzbSgZvz19epB+x+vsSu+PvybXJNNUvOPznusXaxwGmZV/skhDNb
	9Iv/FvNH7JR9Ke2c46mrxFKckWioxVxUnAgAcSsM9dcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xgO42W68Qg2NHpS3+TjrGbvFnQiub
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF0usXmSxOXf8M5E5+yWaxatcfRgce
	jzXz1jB6/P41idFj56y77B6bl9R7XDnRxOrRt2UVo8fnTXIB7FENjDYZqYkpqUUKqXnJ+SmZ
	eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QJcqKZQl5pQChQISi4uV9O0wTQgN
	cdO1gGmM0PUNCYLrMTJAAwlrGDNefb/FXPCKpWLLm6wGxg/MXYycHBICJhLLOp5D2WISF+6t
	Z+ti5OIQEljEKDF3/y4o5zWjxPm3x9lBqngFtCTeP+xlAbFZBFQlJs2fC9bNBhTf/+IGG4gt
	KhAmsXL6FRaIekGJH5PvgdkiAuoS36b0s4MMZRaYyyRx+XoDK0hCWCBWYs/vJUwQ2xYwSnx6
	+RZsEqeApsTGvTcYuxg5gDr0JO5f1AIJMwvIS2xe85Z5AqPALCQ7ZiFUzUJStYCReRWjaGpB
	ckFxUnqukV5xYm5xaV66XnJ+7iZGcGJ4Jr2DcVWDxSFGAQ5GJR7eGzM8Q4RYE8uKK3MPMUpw
	MCuJ8HqZeIUI8aYkVlalFuXHF5XmpBYfYjQFhsBEZinR5Hxg0soriTc0NjEzsjQyN7QwMjZX
	Euc92GodKCSQnliSmp2aWpBaBNPHxMEp1cDI+nSJWMk+znPJnBtczZR2BHmkzhbe49yTP3HX
	UisV9nvTtd7XuE3fN2uNzTfd9w3xKc+2Ks88whvj5vWLf6rL/rf7r3C7p//d97zE0Pm6Y3+V
	lce29ut5+2/Fv9pgV1LJtbhDVnxG+fSLgdfqIjg2+14y53uy68/9sJZdx3v3p0Td7UxZ+PCt
	EktxRqKhFnNRcSIAlagGjCIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 10/24/2014 08:48 PM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 24.10.2014 13:39, Chanwoo Choi wrote:
>> This patch add sleep mode pin configuration using pinctrl subsystem
>> to reduce leakage power-consumption of gpio pin in sleep state.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <Kyungmin Park@samsung.com>
> 
> I suspect a typo in this email address. Kukjin, is this something you
> could fix up when applying (other patches in this series have it correct)?

Sorry about my mistake. I'll resend it right now.

Best Regards,
Chanwoo Choi

