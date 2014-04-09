Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900AbaDIKQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:16:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34377 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbaDIKQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:16:12 -0400
X-AuditID: cbfee68e-b7f566d000002344-1d-53451dea9359
From: Jingoo Han <jg1.han@samsung.com>
To: "'Marek Vasut'" <marex@denx.de>, "'Graham Moore'" <grmoore@altera.com>
Cc: ggrahammoore@gmail.com, "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Brian Norris'" <computersforpeace@gmail.com>,
        "'Artem Bityutskiy'" <artem.bityutskiy@linux.intel.com>,
        "'Sourav Poddar'" <sourav.poddar@ti.com>,
        "'Sascha Hauer'" <s.hauer@pengutronix.de>,
        "'Geert Uytterhoeven'" <geert+renesas@linux-m68k.org>,
        "'Insop Song'" <insop.song@gainspeed.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Alan Tull'" <atull@altera.com>,
        "'Dinh Nguyen'" <dinguyen@altera.com>,
        "'Yves Vandervennet'" <rocket.yvanderv@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1396973570-13995-1-git-send-email-grmoore@altera.com>
 <1396973570-13995-2-git-send-email-grmoore@altera.com>
 <201404091206.45967.marex@denx.de>
In-reply-to: <201404091206.45967.marex@denx.de>
Subject: Re: [PATCH] Add support for flag status register on Micron chips.
Date: Wed, 09 Apr 2014 19:16:10 +0900
Message-id: <000801cf53dc$ba81e820$2f85b860$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9T2371lVlz6hiyS0KQcaKLvRpMpwAAJgEw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t8zfd1Xsq7BBpvPa1q8efyM2aJ/cieb
	xZELa5ktjl9azGwxceVkZotZ948xWcz8sITZYsb2F2wW37ctY7W4vPASkNg1h81id9Mydos3
	bY2MFqt6JrJa/N2+icViWtcjJgcBj9a9E9g85s06weJxtesAi8fOWXfZPTav0PI4dLiD0WPe
	yUCPzUvqPfr/Gnj0bVnF6HH8xnYmj8+b5AJ4orhsUlJzMstSi/TtErgyVk35yVpwgb9iSwtH
	A+Nf7i5GTg4JAROJJZ1/mSBsMYkL99azgdhCAssYJbafy4WpWXRqC2sXIxdQfBGjRMOXecwQ
	zm9GiQddv1lAqtgE1CS+fDnMDmKLCLhJ7LiwgQ2kiFngEIvEpXknodoXMEpsfDMXrINTQF+i
	a912MFtYwEvi8KafYDaLgKrE/Av7wG7iFbCV+Nm6kg3CFpT4MfkeWA2zgJbE+p3HmSBseYnN
	a94CncQBdKu6xKO/uhBHGEnM33GSGaJERGLfi3eMEO/c4ZBYsUEQYpWAxLfJh1ggWmUlNh1g
	hiiRlDi44gbLBEaJWUgWz0KyeBaSxbOQbFjAyLKKUTS1ILmgOCm9yEivODG3uDQvXS85P3cT
	IySp9O1gvHnA+hBjMtD6icxSosn5wKSUVxJvaGxmZGFqYmpsZG5pRpqwkjjvoodJQUIC6Ykl
	qdmpqQWpRfFFpTmpxYcYmTg4pRoY1VZLMAiWGVhnFzDN1V0mpNYt662eYsZ05f+vJX+9r+uZ
	3Gs6G7Lv89uAvSH5VX5fi0KrbLLFne+2bvmn6jb92CSNtJMbpy730V9e82JxfMTZhxLergnP
	ZA7t/LDTcWU+y9INe2feuXjTZaYKz+vsJ+1Wr1UNJu6LfXIpNESounfdGreVbyb6KLEUZyQa
	ajEXFScCAK+z/PJAAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphk+LIzCtJLcpLzFFi42I5/e+xgO4rWddggyP7lS3ePH7GbNE/uZPN
	4siFtcwWxy8tZraYuHIys8Ws+8eYLGZ+WMJsMWP7CzaL79uWsVpcXngJSOyaw2axu2kZu8Wb
	tkZGi1U9E1kt/m7fxGIxresRk4OAR+veCWwe82adYPG42nWAxWPnrLvsHptXaHkcOtzB6DHv
	ZKDH5iX1Hv1/DTz6tqxi9Dh+YzuTx+dNcgE8UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGm
	ZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAPykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0J
	gusxMkADCesYM1ZN+clacIG/YksLRwPjX+4uRk4OCQETiUWntrBC2GISF+6tZ+ti5OIQEljE
	KNHwZR4zhPObUeJB128WkCo2ATWJL18Os4PYIgJuEjsubADrYBY4xCJxad5JVoiOBYwSG9/M
	BevgFNCX6Fq3HcwWFvCSOLzpJ5jNIqAqMf/CPiYQm1fAVuJn60o2CFtQ4sfke2A1zAJaEut3
	HmeCsOUlNq95C3QSB9Ct6hKP/upCHGEkMX/HSWaIEhGJfS/eMU5gFJqFZNIsJJNmIZk0C0nL
	AkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBaeuZ9A7GVQ0WhxgFOBiVeHgVLF2ChVgT
	y4orcw8xSnAwK4nwPmdzDRbiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHkfGBKzSuJNzQ2MTOy
	NDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxsiEhRE8+RtUhFuOLpfhlJ2V
	o/Pyi8djIdGirm3y22a8ETN4uj7gUOOnHQ/dF4QfSTb+fVJR87ZbmEnUDU8Jm6TzXx3Slx7c
	frddyuNDIceTnRGd3/5vz0+8seHP/7mrHgi1WB+1WG393fNSw66zzPNj/u/fl8PwOpxn94y0
	2SfbVKfs23yh7o8SS3FGoqEWc1FxIgBqsuiunwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 09, 2014 7:07 PM, Marek Vasut wrote:
> On Tuesday, April 08, 2014 at 06:12:50 PM, grmoore@altera.com wrote:
> > From: Graham Moore <grmoore@altera.com>
> >
> > Some new Micron flash chips require reading the flag
> > status register to determine when operations have completed.
> >
> > Furthermore, chips with multi-die stacks of the 65nm 256Mb QSPI also
> > require reading the status register before reading the flag status
> > register.
> >
> > This patch adds support for the flag status register in the n25q512a1 and
> > n25q00 Micron QSPI flash chips.
> 
> [...]
> 
> > +static int read_fsr(struct m25p *flash)
> > +{
> > +	ssize_t retval;
> > +	u8 code = OPCODE_RDFSR;
> > +	u8 val;
> > +
> > +	retval = spi_write_then_read(flash->spi, &code, 1, &val, 1);
> > +
> > +	if (retval < 0) {
> > +		dev_err(&flash->spi->dev, "error %d reading FSR\n",
> > +				(int) retval);
> 
> Is the type-cast really needed here? Why ?

The type-cast looks clumsy.
The type of 'retval' is retval; thus, '%zd' can be used,
instead of '%d', as below.

 +		dev_err(&flash->spi->dev, "error %zd reading FSR\n",
 +				retval);


> 
> > +		return retval;
> > +	}
> > +
> > +	return val;
> > +}
> > +/*
> >   * Read configuration register, returning its value in the
> >   * location. Return the configuration register value.
> >   * Returns negative if error occured.
> > @@ -233,7 +259,7 @@ static inline int set_4byte(struct m25p *flash, u32
> > jedec_id, int enable) * Service routine to read status register until
> > ready, or timeout occurs. * Returns non-zero if error.
> >   */
> > -static int wait_till_ready(struct m25p *flash)
> > +static int _wait_till_ready(struct m25p *flash)
> 
> Please avoid using function names that start with underscore .

+1

I agree with Marek Vasut's opinion.
If there is no reason, please don't use it.

Best regards,
Jingoo Han

> [...]
> 
> Thanks!
> 
> Best regards,
> Marek Vasut

