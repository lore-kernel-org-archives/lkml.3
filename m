Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaBFB4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 20:56:15 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:23775 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaBFB4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 20:56:14 -0500
X-AuditID: cbfee690-b7f266d00000287c-d8-52f2ebbcb78b
Message-id: <52F2EBBC.9050804@samsung.com>
Date: Thu, 06 Feb 2014 10:56:12 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 09/18] mfd: max14577: Add "muic" suffix to regmap and
 irq_chip
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-10-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1390911522-28209-10-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsWyRsSkWHfP609BBis6LCymPnzCZvH6haHF
	2aY37Bb3vx5ltPh2pYPJYtPja6wWl3fNYbNYe+Quu8XtxhVsFqe7WR24PHbOusvusWlVJ5vH
	nWt72DzmnQz02Lyk3qNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgyft6+zFiwkqNiyZtjzA2M
	V9m6GDk5JARMJKb97mWFsMUkLtxbDxTn4hASWMoosfDifyaYol1rvjBBJBYxSmzf/5MVwnnF
	KDHnTwMjSBWvgJZE/5XpYB0sAqoS03bOAFvBBhTf/+IGmC0qECaxcvoVFoh6QYkfk++B2SIC
	hhIHd28H62UWuM8kseqIDogtLBAisex9MyPEsjZGib5fe8AGcQp4Sqxe1wvVoCOxv3UaG4Qt
	L7F5zVtmkAYJgZfsEn1LpzFCXCQg8W3yIaBtHEAJWYlNB5ghXpOUOLjiBssERrFZSG6ahWTs
	LCRjFzAyr2IUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIjNLT/55N2MF474D1IcZkoJUTmaVE
	k/OBUZ5XEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxS
	DYxCtSqz/m3v+7DxzL/OT91NJ7WXPU97eu3HTC8VSylb7q7L11elxFyt7fAxj9LkjVow+all
	fVuqods9uzzVJH27SzdObLU58/v2yncze0wkzc74LG56turNrab9/zayn993wZ9V7x/LjG9r
	IsXXv8y45fO/auX7Gt4Zm2J+aKav4TlwONen97CtEktxRqKhFnNRcSIAj6F8GOgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jAd09rz8FGVyeZ2gx9eETNovXLwwt
	zja9Ybe4//Uoo8W3Kx1MFpseX2O1uLxrDpvF2iN32S1uN65gszjdzerA5bFz1l12j02rOtk8
	7lzbw+Yx72Sgx+Yl9R59W1YxenzeJBfAHtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZg
	qGtoaWGupJCXmJtqq+TiE6DrlpkDdJySQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILge
	IwM0kLCGMePn7cuMBSs5Kpa8OcbcwHiVrYuRk0NCwERi15ovTBC2mMSFe+uB4lwcQgKLGCW2
	7//JCuG8YpSY86eBEaSKV0BLov/KdLAOFgFViWk7Z4BNYgOK739xA8wWFQiTWDn9CgtEvaDE
	j8n3wGwRAUOJg7u3g/UyC9xnklh1RAfEFhYIkVj2vpkRYlkbo0Tfrz1ggzgFPCVWr+uFatCR
	2N86jQ3ClpfYvOYt8wRGgVlIdsxCUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmb
	GMEp4Jn0DsZVDRaHGAU4GJV4eDes/xQkxJpYVlyZe4hRgoNZSYT34nOgEG9KYmVValF+fFFp
	TmrxIcZkYBBMZJYSTc4Hpqe8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtloHCgmkJ5akZqemFqQW
	wWxh4uCUamAMbDuoxOLae9CEdcJj1i+in94FrWxbb+9l/ca/cO2XFw6bTvV7Tfw0iyHE5/EO
	wYqpwc9/6cvrqAV8vXr4hPd976e97TH/vnnaVJ2xSbM03zzr8K5Xp/p0r3+XPSL6X1t78jK/
	3YV39knPnnvqe+2b6r02Rr8vs4SFZSV9Pv+0PT5o4sy5SYuMlViKMxINtZiLihMBQl8K+EUD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 09:18 PM, Krzysztof Kozlowski wrote:
> This patch continues the preparation for adding support for max77836
> device to existing max14577 driver.
> 
> Add "muic" suffix to regmap and irq_data fields in maxim_core state
> container to prepare for max77836 support.
> This is only a rename-like patch, new code is not added.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/extcon/extcon-max14577.c     |   17 +++++++++--------
>  drivers/mfd/max14577.c               |   22 +++++++++++-----------
>  drivers/power/max14577_charger.c     |    8 ++++----
>  drivers/regulator/max14577.c         |    2 +-
>  include/linux/mfd/max14577-private.h |    4 ++--
>  5 files changed, 27 insertions(+), 26 deletions(-)
> 

For extcon:
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

For mfd/regulator/charger/extcon of max14577
Tested-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi


