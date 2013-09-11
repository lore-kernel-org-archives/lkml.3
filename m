Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3IKBFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 21:05:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10836 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab3IKBFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 21:05:52 -0400
X-AuditID: cbfee68e-b7f756d000004512-26-522fc1eeb937
From: Jingoo Han <jg1.han@samsung.com>
To: "'Michael Opdenacker'" <michael.opdenacker@free-electrons.com>
Cc: davem@davemloft.net, jogo@openwrt.org, joe@perches.com, mbizon@freebox.fr,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1378537010-7128-1-git-send-email-michael.opdenacker@free-electrons.com>
In-reply-to: <1378537010-7128-1-git-send-email-michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] bcm63xx_enet: remove deprecated IRQF_DISABLED
Date: Wed, 11 Sep 2013 10:05:50 +0900
Message-id: <003101ceae8b$0e6dff20$2b49fd60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6rl3C6Qd+8H+p1QVaB6nqAHTrOWwC83w6w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t8zQ913B/WDDE6/N7eYc76FxWL2/ccs
	FrfXnWKzuLxrDpvFjb0vmC0eTFjFZnFsgZgDu8eWlTeZPJ5susjosb7/PovHlsUZHl9WXWP2
	+LxJLoAtissmJTUnsyy1SN8ugSujYdNStoKJLBVHf01jbWDcwtzFyMkhIWAisXT1NBYIW0zi
	wr31bF2MXBxCAssYJT6+mMQCU/R/yTtmiMQiRomZ32ZDOb8YJebtXcIOUsUmoCbx5cthIJuD
	Q0TAQeL/BxOQGmaBVkaJSV37mUBqhATCJK7s/wBWzykQLnF88zGwM4QFnCQuHLvJBmKzCKhK
	/NnXAraZV8BW4viqe0wQtqDEj8n3wOLMAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCwiICR
	xLtH55khSkQk9r14xwhyj4TAV3aJ89dmQe0SkPg2+RALRK+sxKYD0FCRlDi44gbLBEaJWUg2
	z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIySK+3Yw3jxgfYgxGWj9
	RGYp0eR8YBLIK4k3NDYzsjA1MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAj
	EwenVANjzF+76hMVrR3SR/1To+59O3x5lfbhbdv8rkrOzj0T+iM9tTlnI0fnIo7Xe662r568
	J21tTXTOlN2H556eLFyXH9M987v5RP6AHcbGBo9DJYS5Pq9Zyfg28Zm+s+QeUwWxGzWNe2Oc
	Vjw7vjzYTyFcZe7iA6xBnxdwhc+SXx19ImHq/MUqB7pTlViKMxINtZiLihMBMdYfL/gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsVy+t9jAd13B/WDDI59MraYc76FxWL2/ccs
	FrfXnWKzuLxrDpvFjb0vmC0eTFjFZnFsgZgDu8eWlTeZPJ5susjosb7/PovHlsUZHl9WXWP2
	+LxJLoAtqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNct
	MwfoFCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRsOmpWwFE1kqjv6a
	xtrAuIW5i5GTQ0LAROL/kndQtpjEhXvr2boYuTiEBBYxSsz8NpsZwvnFKDFv7xJ2kCo2ATWJ
	L18OA9kcHCICDhL/P5iA1DALtDJKTOrazwRSIyQQJnFl/wewek6BcInjm4+BbRAWcJK4cOwm
	G4jNIqAq8WdfCwuIzStgK3F81T0mCFtQ4sfke2BxZgEtifU7jzNB2PISm9e8ZQbZKyGgLvHo
	ry5IWETASOLdo/PMECUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzjfSK
	E3OLS/PS9ZLzczcxglPEM+kdjKsaLA4xCnAwKvHw3pDTDxJiTSwrrsw9xCjBwawkwjvVCSjE
	m5JYWZValB9fVJqTWnyIMRno0YnMUqLJ+cD0lVcSb2hsYmZkaWRmYWRibk6asJI478FW60Ah
	gfTEktTs1NSC1CKYLUwcnFINjEW3PZf3f1B8Lr7GYfbk0sqDxwN4J+ld0CySWLZsqi//9eaH
	G+yKub+mZnAv+nzrj1flBF1HU3sDh8stiVGWyatEJQ7/nOymuPZQToh8iW/peqG2W1fLdHRT
	AvgaDvzZlbjynjSDelL+Vf+8Vas2rtkScrt6gQr7OWbDD8lHZGNqpnW9+XktU4mlOCPRUIu5
	qDgRANMhaPhVAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 07, 2013 3:57 PM, Michael Opdenacker wrote:
> 
> This patch proposes to remove the IRQF_DISABLED flag from
> drivers/net/ethernet/broadcom/bcm63xx_enet.c
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/net/ethernet/broadcom/bcm63xx_enet.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

