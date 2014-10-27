Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaJ0Kfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:35:44 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33266 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaJ0Kfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:35:42 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-7c-544e1ffcfa91
Message-id: <1414406135.1674.2.camel@AMDC1943>
Subject: Re: [PATCH v4 2/3] regulator: max77686: Implement suspend disable for
 some LDOs
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Mon, 27 Oct 2014 11:35:35 +0100
In-reply-to: <544E1F48.9050105@collabora.co.uk>
References: <1414403066-7872-1-git-send-email-k.kozlowski@samsung.com>
 <1414403066-7872-3-git-send-email-k.kozlowski@samsung.com>
 <544E19A4.6040603@collabora.co.uk> <1414405641.1674.1.camel@AMDC1943>
 <544E1F48.9050105@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xa7p/5P1CDL7d4bfYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g0bvgKpvF2aY37BbfrnQwWWx6fI3V4vKuOWwWM87vY7K4
	fZnXYu2Ru+wOfB4tzT1sHn+fX2fx+LvqBbPHzll32T02repk89i8pN6jb8sqRo/Pm+QCOKK4
	bFJSczLLUov07RK4MnbvnMVcsIq14tNMiwbGDpYuRk4OCQETieU7XrND2GISF+6tZ+ti5OIQ
	EljKKPFt1k8mCOczo8SxJX8ZQap4BfQktl9YxgRiCwtESVy4eooNxGYTMJbYvHwJmC0iYCdx
	Y/VDZpBmZoGfzBKP2o6BrWMRUJVob1vIDGJzCuhLTH7QxA6x4QOjxIWH+8HuYBZQl5g0bxFQ
	EQfQTcoSjf1uEIsFJX5MvscCUSIvsXnNW+YJjAKzkHTMQlI2C0nZAkbmVYyiqaXJBcVJ6blG
	esWJucWleel6yfm5mxghUfR1B+PSY1aHGAU4GJV4eCcU+4YIsSaWFVfmHmKU4GBWEuF1/AkU
	4k1JrKxKLcqPLyrNSS0+xMjEwSnVwNiwjjvlFt+bALf7VY0zrD/u9/WrX2Jn715Ur3WTfXeU
	PNPGdxJakZJX5n8sqp3/U2lGVZnUj0envslNbmuOvPH9QtyaG2+b/P1L+rvdtFJ3nKheufQQ
	64tpLibsco+5O2Z+Kf8cI3F2qexTPffieVGyW3/qVjqqRG/n5TdfdFn3n6XH+qmHo5RYijMS
	DbWYi4oTAWTLUsuAAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-10-27 at 11:32 +0100, Javier Martinez Canillas wrote:
> On 10/27/2014 11:27 AM, Krzysztof Kozlowski wrote:
> > 
> > Storing opmode in non-shifted form is intuitive also to me. That's way I
> > slipped the bug in previous version.
> > 
> 
> Great.
> 
> > I'll change this to non-shifted opmode. The patch will grow bigger but
> > the code should be more readable.
> > 
> 
> Maybe split in two patches? A preparatory that adds max77686_get_opmode_shift()
> and changes the current driver and a second one that implements suspend disable
> for LDOs?

Yes, that was the plan :).

> 
> > Thanks!
> 
> You are welcome.
> 
> Best regards,
> Javier

