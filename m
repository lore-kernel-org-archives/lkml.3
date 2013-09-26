Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab3IZSO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:14:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65122 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3IZSOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:14:24 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-a5-5244797ee78a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        devicetree@vger.kernel.org, t.figa@samsung.com,
        m.szyprowski@samsung.com, k.debski@samsung.com, s.nawrocki@samsung.com,
        t.stanislaws@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC 3/3] Samsung: DT: Add Device tree for S5PC110/S5PV210 Boards
Date: Thu, 26 Sep 2013 20:14:16 +0200
Message-id: <4009668.rmW0ykQNyc@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1380214769-7685-4-git-send-email-m.krawczuk@partner.samsung.com>
References: <1380214769-7685-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1380214769-7685-4-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t9jAd36Spcgg8dbOCzmHznHanHu1UpG
	ix+vL7BZ9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5LU6vOcVssfbIXXaLpdcvMllM
	mL6WxeLwigNMFofftLNavDrYxmKxfsZrFot57S9ZHYQ81sxbw+jR0tzD5rHg8xV2j5XLv7B5
	bF5S73Hw3R4mj74tqxg9Pm+S89g4NzSAM4rLJiU1J7MstUjfLoErY8aiN6wFm1grHp5bz9bA
	uIqli5GTQ0LARKJ1bicjhC0mceHeerYuRi4OIYFFjBLzpv1nhXBamCTOfHwLVsUmYCUxsX0V
	mC0iYCrx7u41sA5mgVvMEq3bL7GCJIQF/CSuvDvADGKzCKhKrF20Dmwdr4CmxJP519lBbFEB
	T4lPk5aC1XAC1b/bOAFq20RGiVOTZ7JCNAhK/Jh8D6yZWUBeYt/+qawQto7E/tZpbBMYBWYh
	KZuFpGwWkrIFjMyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYJj75nUDsaVDRaHGAU4GJV4
	eAUyXIKEWBPLiitzDzFKcDArifCujwUK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCe
	WJKanZpakFoEk2Xi4JRqYAx+feV8pe/C33o3Qj6lTu/RWeK6M6o+5eec1KlGXub/Ps+TmZux
	x+Zj/1uDU5OSbn45N51LS9FKMv/g1w33g/efEVx5a7dK6bOWC2u2++797Hn24JpPwTEbduqc
	8rs9ra1og/m6d/zLV71hS1kZL18xuWnnFt//d5tPyS50X//3S3+Cb6n35+4EJZbijERDLeai
	4kQAS8J/XLkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Mateusz,

On Thursday, September 26, 2013 06:59:29 PM Mateusz Krawczuk wrote:
> Add DTS for s5pc110 boards: goni, aquila, smdkc110
> s5pv210: smdkv210, tiny210
> Torbreck is replaced by FriendlyARM Tiny210 board.

Could you please explain what do you mean by "replaced" here?

Looking at the current board code it should be pretty easy to add
device tree support for Torbreck if needed (it is just a subset of
smdkc110 support + mmc). Then you would have all mach-s5pv210 boards
covered by the device tree and could plan for the removal of non-DT
code in the near future.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

