Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaKLHGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:06:13 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51504 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaKLHGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:06:10 -0500
X-AuditID: cbfee68e-f79b46d000002b74-a6-546306e05cd1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Baluta'" <daniel.baluta@intel.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Joe Perches'" <joe@perches.com>,
        "'Jonathan Cameron'" <jic23@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Mauro Carvalho Chehab'" <mchehab@osg.samsung.com>,
        "'Antti Palosaari'" <crope@iki.fi>,
        "'Hartmut Knaack'" <knaack.h@gmx.de>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Peter Meerwald'" <pmeerw@pmeerw.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1415716594-18145-1-git-send-email-daniel.baluta@intel.com>
In-reply-to: <1415716594-18145-1-git-send-email-daniel.baluta@intel.com>
Subject: Re: [PATCH] MAINTAINERS: Add IIO include files
Date: Wed, 12 Nov 2014 16:06:52 +0900
Message-id: <000801cffe47$3c87f570$b597e050$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/9vLbT5tzTJzVhQNegPyPSpZbsSwAidR1Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t8zI90HbMkhBndPc1vMWb+GzeJ783s2
	i53bVrFazDnfwmLRvHg9m8XlhZdYLR40rWKymH3/MYvFrv9vmC2WTJ7PajHvyDsWi8u75rBZ
	rH5WYfF71zF2Bz6PLStvMnl8+BjncfjrQhaPxXteMnlsWtXJ5nFixm8Wj/1z17B7LHlziNVj
	S/9ddo8vq64xe5xvPsLo0bdlFaPH501yAbxRXDYpqTmZZalF+nYJXBk9uy+wFVxiq3j2spWp
	gXEtaxcjJ4eEgInEsinTGCFsMYkL99azdTFycQgJLGOU2PTwFBNMUfuiXSwQiUWMEo/3bWOH
	cH4xSjxffw2snU1ATeLLl8PsILaIgK7EtwmrWUGKmAU6WSS+bTgLlhAScJfYtmIW0A4ODk4B
	D4l/v2RBwsIC5hIXV55hA7FZBFQlHu/4ywJi8wrYSnxcvpEJwhaU+DH5HlicWUBLYv3O40wQ
	trzE5jVvmUFGSgioSzz6qwtxgpHErTMzocpFJPa9eMcIco6EwA0OiVcNr5ggdglIfJt8iAWi
	V1Zi0wFmiIclJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4oTkovMtIrTswtLs1L
	10vOz93ECEkofTsYbx6wPsQowMGoxMObsTkpRIg1say4MvcQoynQRROZpUST84FpK68k3tDY
	zMjC1MTU2Mjc0kxJnDdB6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBka9iYxvNXiP/+p9
	5eN6vGG3q3T4T4P/tn7Kfxi9LoRadErHWBzi7/Tz+HqVcVdW6uo73ArdeTWvOXc+3nj28Y2c
	TZLduZKrWyX3h7lH7hJYEH1geZRu7YapecefMXfJyFpvVvhpPeMeW1D0Z8at878pLVDtbVhZ
	zCJlK1+6fqnQFMeSh6aWPUosxRmJhlrMRcWJAL6/ep4jAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t9jAd0HbMkhBvOWsVnMWb+GzeJ783s2
	i53bVrFazDnfwmLRvHg9m8XlhZdYLR40rWKymH3/MYvFrv9vmC2WTJ7PajHvyDsWi8u75rBZ
	rH5WYfF71zF2Bz6PLStvMnl8+BjncfjrQhaPxXteMnlsWtXJ5nFixm8Wj/1z17B7LHlziNVj
	S/9ddo8vq64xe5xvPsLo0bdlFaPH501yAbxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZm
	Boa6hpYW5koKeYm5qbZKLj4Bum6ZOUAPKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC
	6zEyQAMJ6xgzenZfYCu4xFbx7GUrUwPjWtYuRk4OCQETifZFu1ggbDGJC/fWs3UxcnEICSxi
	lHi8bxs7hPOLUeL5+muMIFVsAmoSX74cZgexRQR0Jb5NWM0KUsQs0Mki8W3DWbCEkIC7xLYV
	s4BGcXBwCnhI/PslCxIWFjCXuLjyDBuIzSKgKvF4x1+wzbwCthIfl29kgrAFJX5MvgcWZxbQ
	kli/8zgThC0vsXnNW2aQkRIC6hKP/upCnGAkcevMTKhyEYl9L94xTmAUmoVk0iwkk2YhmTQL
	ScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHp6pn0DsZVDRaHGAU4GJV4eDM2J4UI
	sSaWFVfmHmKU4GBWEuH99BUoxJuSWFmVWpQfX1Sak1p8iNEU6NGJzFKiyfnAVJpXEm9obGJm
	ZGlkZmFkYm6uJM57sNU6UEggPbEkNTs1tSC1CKaPiYNTqoFReFKEstePlRevFi+cJKAjc7HC
	vO2n9NrMGUfCphvszd55h034/82NE1Z+TO7YGutqPmcFh13CEpUdO3Rn/vHtT5vtYSChGfjv
	kWCX98PW7NawQ2KGGhmeK7x73lUcvWRbqL5i4VH/DZ6WOQ8s3xv/aQ/doXGcuyw0vsdz/e/V
	8lXSLo8dy6OUWIozEg21mIuKEwHjSoxLbQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 11, 2014 11:37 PM, Daniel Baluta wrote:
> 
> Files under include/linux/iio were not reported as part
> of the IIO subsystem.
> 
> Reported-by: Cristina Ciocan <cristina.ciocan@intel.com>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>

(+cc Hartmut Knaack, Lars-Peter Clausen, Peter Meerwald)

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b2f927b..ebb9c38 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4631,6 +4631,7 @@ L:	linux-iio@vger.kernel.org
>  S:	Maintained
>  F:	drivers/iio/
>  F:	drivers/staging/iio/
> +F:	include/linux/iio/
> 
>  IKANOS/ADI EAGLE ADSL USB DRIVER
>  M:	Matthieu Castet <castet.matthieu@free.fr>
> --
> 1.9.1

