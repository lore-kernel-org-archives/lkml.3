Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbaJ2KoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:44:09 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15374 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbaJ2KoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:44:07 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f956d000005ed7-9c-5450c4f4b9b5
Content-transfer-encoding: 8BIT
Message-id: <1414579442.18868.13.camel@AMDC1943>
Subject: Re: [PATCH v5 3/4] regulator: max77686: Add suspend disable for some
 LDOs
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Wed, 29 Oct 2014 11:44:02 +0100
In-reply-to: <20141029103140.GY18557@sirena.org.uk>
References: <1414411911-5539-1-git-send-email-k.kozlowski@samsung.com>
 <1414411911-5539-4-git-send-email-k.kozlowski@samsung.com>
 <20141028223121.GH18557@sirena.org.uk> <1414574413.18868.6.camel@AMDC1943>
 <20141029100142.GR18557@sirena.org.uk> <1414577934.18868.7.camel@AMDC1943>
 <20141029103140.GY18557@sirena.org.uk>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xq7pfjgSEGFxfLGGxccZ6VotJ6w4w
	WUx9+ITN4vqX56wW84+cY7U4+rvAonfBVTaLs01v2C2+Xelgstj0+BqrxeVdc9gsZpzfx2Rx
	+zKvxdojd9kd+DxamnvYPP4+v87i8XfVC2aPnbPusntsWtXJ5rF5Sb1H35ZVjB6fN8kFcERx
	2aSk5mSWpRbp2yVwZXyYtY694BFrxb71U9kbGE+wdDFyckgImEjs3L+BFcIWk7hwbz0biC0k
	sJRRYu3vKBCbV0BQ4sfke0D1HBzMAvISRy5lg4SZBdQlJs1bxNzFyAVU/plR4uL/XkaIegOJ
	led2gM0RFgiR+HbtABOIzSZgLLF5+RKwuIiAssTV73tZQJqZBaaxSCz4eAmsmUVAVaJp5zqw
	Ik6ghpVfF0NtOMYksWz7Z3aQKySAuhv73SYwCsxCct8shPtmIblvASPzKkbR1NLkguKk9Fwj
	veLE3OLSvHS95PzcTYyQCPq6g3HpMatDjAIcjEo8vBEs/iFCrIllxZW5hxglOJiVRHjf7Q0I
	EeJNSaysSi3Kjy8qzUktPsTIxMEp1cDIbXFcft0U+40zpNdtn5ybLiQj7Zx5h0Va2faG54Jp
	ucd6jlYxb/PXSnVwUeedxVqVPeXSi28sTb6zq4X6JmtqnmsoE9z0+I/Nx/w1NxZVM7rEf2u9
	er+BWdvryKreynmdxTsezV22rF7Wiu/0GTE+meBFD1+45TLsV7hiqv2+Y8uOxTtW/Z6qxFKc
	kWioxVxUnAgANFKwYX4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-10-29 at 10:31 +0000, Mark Brown wrote:
> On Wed, Oct 29, 2014 at 11:18:54AM +0100, Krzysztof Kozlowski wrote:
> > On śro, 2014-10-29 at 10:01 +0000, Mark Brown wrote:
> 
> > > No, this isn't suspend enable control - this is normal, standard enable
> > > control and the device has no suspend enable control.
> 
> > You mean that for such regulator the driver shouldn't implement
> > suspend_enable()?
> 
> Yes, if there is no separate control of suspend mode in hardware then of
> course the driver shouldn't implement operations for things it doesn't
> have.

Oh, thanks! I'll send fixed patch.

This means that probably the max77802 ("mirrored" driver) should be
fixed...

Best regards,
Krzysztof

