Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaDKEo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 00:44:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62937 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaDKEoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 00:44:55 -0400
X-AuditID: cbfee68f-b7f156d00000276c-fb-53477345c21b
Message-id: <53477347.1080603@samsung.com>
Date: Fri, 11 Apr 2014 13:44:55 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Olof Johansson <olof@lixom.net>
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 12/27] ARM: dts: exynos3250: Add default interrupt-parent
 connected with GIC
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397124377-16969-4-git-send-email-cw00.choi@samsung.com>
 <20140411040050.GD14934@quad.lixom.net>
In-reply-to: <20140411040050.GD14934@quad.lixom.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWyRsSkWNe12D3YYMNXQ4vPH1rYLSbdn8Bi
	0bvgKpvF2aY37BabHl9jtbi8aw6bxYzz+5gsTl3/DGRNfslmsX7GaxaLvTsnMzpwe2xeUu9x
	5UQTq0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl7Jy5iq3gJmfFvb3r2RoYX7B3MXJwSAiY
	SJyYaN3FyAlkiklcuLeeDcQWEljKKLF1ZiZE3ESiedsGoDgXUHwRo8SBbQ+ZIJzXjBK9Xzez
	glTxCmhJfL5/nQXEZhFQlZi6fgYjiM0GFN//4gbYVFGBMImV06+wQNQLSvyYfA/MFhFQlnjS
	dokZZCizwBQmibsvP4AlhAWSJE6dP8kMsW010EnXFoJN4gS6aev/hcwgNrOAjsT+1mlsELa8
	xOY1b8EaJAQesUs8XXSIHeIkAYlvkw+xQPwsK7HpADPEb5ISB1fcYJnAKDYLyVGzkIydhWTs
	AkbmVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiBUXn637P+HYx3D1gfYkwGWjmRWUo0OR8Y
	1Xkl8YbGZkYWpiamxkbmlmakCSuJ895/mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVFi
	o+GjjraVC9Jrt1j/XdKjGh5TU25x6sG2Vz8Pf5i4cu7GLdEbTq7YtULw/EmJe8yvT//Y8azL
	qWnB6wWe+xYqTF/yUl9UXK8wVvT61E2f/klfXNW82nXqq2CZbw6rjugfq+lmuXM9OFar2uOb
	BttdY1324GkTHu1Y76G2LP7y4/wGpw9316jXKbEUZyQaajEXFScCAPSoY7TgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jAV3XYvdgg93/NSw+f2hht5h0fwKL
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyOHX9M5A1+SWbxfoZr1ks9u6czOjA7bF5Sb3H
	lRNNrB59W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCX
	mJtqq+TiE6DrlpkDdJWSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMWPn
	zFVsBTc5K+7tXc/WwPiCvYuRk0NCwESiedsGNghbTOLCvfVANheHkMAiRokD2x4yQTivGSV6
	v25mBaniFdCS+Hz/OguIzSKgKjF1/QxGEJsNKL7/xQ2wSaICYRIrp19hgagXlPgx+R6YLSKg
	LPGk7RIzyFBmgSlMEndffgBLCAskSZw6f5IZYttqRomt1xaCTeIEum/r/4XMIDazgI7E/tZp
	bBC2vMTmNW+ZJzAKzEKyZBaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI77
	Z9I7GFc1WBxiFOBgVOLhPXDJLViINbGsuDL3EKMEB7OSCK+Zv3uwEG9KYmVValF+fFFpTmrx
	IcZkYBhMZJYSTc4HpqS8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh
	4uCUamDkccr9oSE47a57s1mb4izNTYbrF7yyVZrXJ95lzHni1dJt/dIKZ5fOif/wY1/32lN8
	AdZGKq2V8Vlrs+/Pb6wXybLYe+u2bz5fXI2fRuCt+ec2Tcnh+7L6zbwlM5qWrN64MeVx1dc7
	VjpWz1aslq+fKG8RwtI//TnzvsNf1YUbpRiF9rFcvlavxFKckWioxVxUnAgAKtNHtT8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/11/2014 01:00 PM, Olof Johansson wrote:
> On Thu, Apr 10, 2014 at 07:06:02PM +0900, Chanwoo Choi wrote:
>> This patch add interrupt-parent node to connected with GIC.
>> All interrupt-related dt nodes need default interrupt-parent node.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> There's no point in splitting these off in separate patches; fold them
> into one patch that introduces the SoC dtsi, please.

OK, I will consolidate following two patches into one patch.

[PATCH 11/27] ARM: dts: exynos3250: Add GIC dt node for Exynos3250
[PATCH 12/27] ARM: dts: exynos3250: Add default interrupt-parent connected with GIC

> 
> Also, you missed your sign-off on one or two of the previous ones, but that
> won't be a problem once they're folded in. :)

I'll add my sign-off to all the patches on next posting(v2).

> 
> Finally, if the code is yours, and you're posting it, then Kyungmin should
> probably have a Reviewed-by or Acked-by tag, not a Signed-off-by. See
> Documentation/SubmittingPatches, section 12 and 13.
> 

OK, I'll change from 'Signed-off-by' to 'Acked-by'.

Thanks,

Best Regards,
Chanwoo Choi

