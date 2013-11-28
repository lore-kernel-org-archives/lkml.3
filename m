Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab3K1DxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 22:53:16 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:57989 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab3K1DxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 22:53:13 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-ca-5296be2731b0
Message-id: <5296BE27.1040904@samsung.com>
Date: Thu, 28 Nov 2013 12:53:11 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v4 2/5] extcon: max14577: Add extcon-max14577 driver to
 support MUIC device
References: <1385135469-27044-1-git-send-email-k.kozlowski@samsung.com>
 <1385135469-27044-3-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1385135469-27044-3-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsWyRsSkQFd937Qgg6/bNSwObtW02DhjPavF
	1IdP2CzmHznHajFx5WRmiwN/djBanHu1ktHi9QtDi7NNb9gt7n89ymjx7UoHk8Wmx9dYLRa2
	LWGxuLxrDpvF2iN32S1uN65gs5gwfS2LxeEVB5gs1r2czmJxupvV4tXBNhYHUY8189Yweiz4
	fIXdY0L/J0aPnbPusnusXP6FzWPzCi2PTas62TxerZ7J6nHn2h42j3knAz02L6n36NuyitHj
	8yY5j41zQwP4orhsUlJzMstSi/TtErgyVnQ+YS64xFYxZd4F1gbGzaxdjJwcEgImEgvuXWOB
	sMUkLtxbzwZiCwksZZTY/JoTpubK4TuMXYxcQPHpjBJ9h3awQBS9YpR42VkBYvMKaEms+/GZ
	uYuRg4NFQFVi7Q4XkDAbUHj/ixtgM0UFwiRWTr/CAlEuKPFj8j0wW0TAUOLg7u1MIPOZBTrY
	JNb9m8EOkhAWSJT4enw/E8TiVkaJhkfr2EAWcAp4SLS8kAGpYRbQkdjfOo0NwpaX2LzmLTNI
	vYTAFw6JeZc2gQ1iERCQ+Db5EAtIr4SArMSmA8wQj0lKHFxxg2UCo9gsJDfNQjJ2FpKxCxiZ
	VzGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmIEJpPT/5717mC8fcD6EGMy0MqJzFKiyfnAZJRX
	Em9obGZkYWpiamxkbmlGmrCSOG/Sw6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzO2RzP
	Ny6+5fmySfTMg3enJq92/OOlrFoSveXQZ2ulrofzFkcVuOwP6Nz/gfPeaW+pg1Oleudl1B0x
	P7BUz8V84a810bqVou9ebf2/s08sSmm+1a7nr4zfl9kzsbkFRT5oCZwzL9jGLi3k7mvFPb2T
	+Ze8jlGecExJ43DIl0i3cyqiAU/fehgrsRRnJBpqMRcVJwIAjP8zPDwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42I5/e+xoK76vmlBBuuOy1kc3KppsXHGelaL
	qQ+fsFnMP3KO1WLiysnMFgf+7GC0OPdqJaPF6xeGFmeb3rBb3P96lNHi25UOJotNj6+xWixs
	W8JicXnXHDaLtUfuslvcblzBZjFh+loWi8MrDjBZrHs5ncXidDerxauDbSwOoh5r5q1h9Fjw
	+Qq7x4T+T4weO2fdZfdYufwLm8fmFVoem1Z1snm8Wj2T1ePOtT1sHvNOBnpsXlLv0bdlFaPH
	501yHhvnhgbwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4
	BOi6ZeYA/aykUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzFjR+YS54BJb
	xZR5F1gbGDezdjFyckgImEhcOXyHEcIWk7hwbz1bFyMXh5DAdEaJvkM7WEASQgKvGCVedlaA
	2LwCWhLrfnxm7mLk4GARUJVYu8MFJMwGFN7/4gYbiC0qECaxcvoVFohyQYkfk++B2SIChhIH
	d29nApnPLNDBJrHu3wx2kISwQKLE1+P7mSAWtzJKNDxaxwaygFPAQ6LlhQxIDbOAjsT+1mls
	ELa8xOY1b5knMArMQrJjFpKyWUjKFjAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQITlbP
	pHYwrmywOMQowMGoxMMroTMtSIg1say4MvcQowQHs5IIr0IxUIg3JbGyKrUoP76oNCe1+BBj
	MjAEJjJLiSbnAxNpXkm8obGJmZGlkbmhhZGxOWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFw
	SjUw7i+0vSfB1nvbsPxY8aKe6oRf4SLq9qttSl4XWW2N7A58euzsD+foVRm5jsmdQZzK39W3
	3XfaYftAaPk1mw63T4+vRW+Z/W/pq/4+xqxd+gFOoSmvcieov+czf+BiIvUk/5PKu5dX58zd
	8dj1SHys0MXpJQqOYar2iqINj6PFTByumHCc3PRRiaU4I9FQi7moOBEAUGCpuZoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2013 12:51 AM, Krzysztof Kozlowski wrote:
> From: Chanwoo Choi <cw00.choi@samsung.com>
> 
> This patch supports Maxim MAX14577 MUIC(Micro USB Interface Controller)
> device by using EXTCON subsystem to handle various external connectors.
> The max14577 device uses regmap method for i2c communication and
> supports irq domain.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/extcon/Kconfig           |   10 +
>  drivers/extcon/Makefile          |    1 +
>  drivers/extcon/extcon-max14577.c |  752 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 763 insertions(+)
>  create mode 100644 drivers/extcon/extcon-max14577.c
> 

Applied it.

Thanks,
Chanwoo Choi

