Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3CKXy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:54:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45739 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3CKXyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:54:25 -0400
X-AuditID: cbfee68e-b7f946d000001e37-b3-513e6eafb7d0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <005f01ce1e0c$b7dbcfc0$27936f40$%han@samsung.com>
 <20130311152801.fd07ff051885bb1c98fe14f5@linux-foundation.org>
In-reply-to: <20130311152801.fd07ff051885bb1c98fe14f5@linux-foundation.org>
Subject: Re: [PATCH] backlight: l4f00242t03: check return value of
 regulator_enable()
Date: Tue, 12 Mar 2013 08:54:23 +0900
Message-id: <008d01ce1eb3$c1a1d1b0$44e57510$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ep7JLA/7/3YnESCq56B5yOkXMEwAC9bvA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zY931eXaBBltmWFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MY3d/MBXMEaxY1L2WpYHxM28XIyeHhICJxIO5m5ghbDGJC/fW
	s3UxcnEICSxjlOg8/Z4NpqjjchtUYhGjxMO7z6Gc2UwSp9/eYASpYhNQk/jy5TB7FyMHh4iA
	vkRbiwZImFmgVGLrg/csILaQQJ3E5E03WEFsTgFviZ37/rKAlAsLhEv8mwI2hUVAVWLpxd3s
	IDavgK3Eh/tTmSBsQYkfk++xQIzUkli/8zgThC0vsXnNW2aQMRIC6hKP/uqChEUEjCSerlvA
	ClEiIrHvxTtGiFeWsUssf1cMsUpA4tvkQywQrbISmw5Ag0FS4uCKGywTGCVmIVk8C8niWUgW
	z0KyYQEjyypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MkKjq28F484D1IcZkoPUTmaVEk/OB
	UZlXEm9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkbJ
	73lMx/wvPahTWtjRkVi2yNf481JdZ71DFZViIZ+zpy8R3qEh/lbX9V3L0xi/pJKXJlfPpMRs
	/GlaMEte8NyGR/f4EnVyki163v2KW5dusOHH/nv7JifxRgWtOCaTZ+QUznNXOO3o6pmxTFUq
	2yR1pGscPh7ep3r1e2994GaZWRNq4tlfNymxFGckGmoxFxUnAgCF5qX9wAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO76PLtAg86HZhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x49jdH0wFcwQrFnWvZWlg
	/MzbxcjJISFgItFxuY0NwhaTuHBvPZDNxSEksIhR4uHd51DObCaJ029vMIJUsQmoSXz5cpi9
	i5GDQ0RAX6KtRQMkzCxQKrH1wXsWEFtIoE5i8qYbrCA2p4C3xM59f1lAyoUFwiX+TQGbwiKg
	KrH04m52EJtXwFbiw/2pTBC2oMSPyfdYIEZqSazfeZwJwpaX2LzmLTPIGAkBdYlHf3VBwiIC
	RhJP1y1ghSgRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqX
	rpecn7uJERy1z6R3MK5qsDjEKMDBqMTDq/DNNlCINbGsuDL3EKMEB7OSCG9lil2gEG9KYmVV
	alF+fFFpTmrxIcZkoEcnMkuJJucDE0peSbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tS
	s1NTC1KLYLYwcXBKNTBKn5yfedb07a25LicPGO7Plp/1b/3JE/seLZ7mN/3b4Walqs3Hjb5v
	dJGyZP+rdcyWcV6VQOfBu1UGVtpCtmbWXveYLAUDXF6XpVu9jVnjefgAv9nnSa+t05dwPjVO
	TV7AY3bCx37vlg9bhE6l97M3/9D/Ivegtv73JZdSgZ7Xy26dbJKcJpShxFKckWioxVxUnAgA
	ESRdCx4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 12, 2013 7:28 AM, Andrew Morton wrote:
> 
> On Mon, 11 Mar 2013 12:58:41 +0900 Jingoo Han <jg1.han@samsung.com> wrote:
> 
> > The regulator_enable() was marked as as __must_check, therefore,
> > the return value of regulator_enable() should be checked.
> > Also, this patch checks return value of regulator_set_voltage().
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/video/backlight/l4f00242t03.c |   27 ++++++++++++++++++++++-----
> >  1 files changed, 22 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
> > index fb61557..8d54c3c 100644
> > --- a/drivers/video/backlight/l4f00242t03.c
> > +++ b/drivers/video/backlight/l4f00242t03.c
> > @@ -51,14 +51,31 @@ static void l4f00242t03_lcd_init(struct spi_device *spi)
> >  	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
> >  	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
> >  	const u16 cmd[] = { 0x36, param(0), 0x3A, param(0x60) };
> > +	int ret;
> >
> >  	dev_dbg(&spi->dev, "initializing LCD\n");
> >
> > -	regulator_set_voltage(priv->io_reg, 1800000, 1800000);
> > -	regulator_enable(priv->io_reg);
> > +	ret = regulator_set_voltage(priv->io_reg, 1800000, 1800000);
> > +	if (ret) {
> > +		dev_err(&spi->dev, "failed to set the IO regulator voltage.\n");
> > +		return;
> > +	}
> > +	ret = regulator_enable(priv->io_reg);
> > +	if (ret) {
> > +		dev_err(&spi->dev, "failed to enable the IO regulator.\n");
> > +		return;
> > +	}
> >
> > -	regulator_set_voltage(priv->core_reg, 2800000, 2800000);
> > -	regulator_enable(priv->core_reg);
> > +	ret = regulator_set_voltage(priv->core_reg, 2800000, 2800000);
> > +	if (ret) {
> > +		dev_err(&spi->dev, "failed to set the core regulator voltage.\n");
> > +		return;
> 
> Should the IO regulator be disabled before returning?
Hi Andrew,

OK, I see.
I will send v2 patch.
Thank you :)

Best regards,
Jingoo Han

> 
> > +	}
> > +	ret = regulator_enable(priv->core_reg);
> > +	if (ret) {
> > +		dev_err(&spi->dev, "failed to enable the core regulator.\n");
> > +		return;
> > +	}
> 
> Ditto.

