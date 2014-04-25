Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaDYNpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:45:41 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35483 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbaDYNpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:45:36 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-b8-535a66fcd7d6
Message-id: <1398433531.30695.3.camel@AMDC1943>
Subject: Re: [PATCH part2 2/6] regulator/mfd: max14577: Export symbols for
 calculating charger current
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Anton Vorontsov <anton@enomsg.org>
Date: Fri, 25 Apr 2014 15:45:31 +0200
In-reply-to: <20140424124803.GW12304@sirena.org.uk>
References: <1398264640-12122-1-git-send-email-k.kozlowski@samsung.com>
 <1398264640-12122-3-git-send-email-k.kozlowski@samsung.com>
 <20140424124803.GW12304@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t/xK7p/0qKCDSZ80bc4uFXTYuOM9awW
	Ux8+YbOY9OQ9s8XElZOZLc42vWG3uP/1KKPFtysdTBaXd81hs1h75C67xeluVov1M16zOPB4
	TOj/xOixc9Zddo/NK7Q8Nq3qZPO4c20Pm8e8k4EefVtWMXp83iQXwBHFZZOSmpNZllqkb5fA
	lbF37S3mgj0sFS+vnWBtYDzB3MXIySEhYCLxYeNsFghbTOLCvfVsXYxcHEICSxkl3v/7xgjh
	fGaU2PruD1gHr4C+xLp/y9hBbGGBDInNf7eBxdkEjCU2L1/CBmKLCChLXP2+lwWkmVngCLPE
	jvN7wBIsAqoSTUv7wGxOoIbpS7+wQGxYxyhxrPUJWIJZQF1i0rxFUPcpS8zbf4wJYrOgxI/J
	91ggauQlNq95yzyBUWAWkpZZSMpmISlbwMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMk
	Zr7uYFx6zOoQowAHoxIP7wqjyGAh1sSy4srcQ4wSHMxKIrwf/KKChXhTEiurUovy44tKc1KL
	DzEycXBKNTBe0Tnwy1KjZ+IRW46NCUcE73T8f5xTwKBta/HlWP88F+Z19956Tnh3cNKyDO6f
	Jk3r3zNs3T6vmseFwdz+67SvHXd2H0wyPmhv6BdwmvfIW54/nTlLrtlKqcbX+ghovXx5qvnm
	vuQtG+8r9URzFpdcO1+34mDooeXK66fX9Bs7tW1kdl44mdFGiaU4I9FQi7moOBEAKc2iH3cC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-04-24 at 13:48 +0100, Mark Brown wrote:
> On Wed, Apr 23, 2014 at 04:50:36PM +0200, Krzysztof Kozlowski wrote:
> > This patch prepares for changing the max14577 charger driver to allow
> > configuring battery-dependent settings from DTS.
> 
> Acked-by: Mark Brown <broonie@linaro.org>

Hi Mark,

Thanks for the ack, however this patch already got it:
https://lkml.org/lkml/2014/2/7/640

I need your ack on the fifth patch:
 * [PATCH part2 5/6] regulator: max14577: Implement SUSPEND mode for
   MAX77836 LDO-s

Best regards,
Krzysztof



