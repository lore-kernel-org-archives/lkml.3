Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3IWOEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:04:08 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17798 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3IWOEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:04:04 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-c6-52404a5399c7
From: Tomasz Figa <t.figa@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>, kgene.kim@samsung.com,
        ben-linux@fluff.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] spi: s3c64xx: Add missing compatibles
Date: Mon, 23 Sep 2013 16:03:48 +0200
Message-id: <1668307.AS5AU6asQx@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <20130923135042.GH21013@sirena.org.uk>
References: <1379929545-27517-1-git-send-email-m.krawczuk@partner.samsung.com>
 <20130923135042.GH21013@sirena.org.uk>
MIME-version: 1.0
Content-type: multipart/signed; boundary=nextPart5657219.y94VlvC6mD;
 micalg=pgp-sha1; protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e/4Zd1gL4cgg0OXhSwmrTvAZDH14RM2
	i/lHzrFa9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaLxo832S1OrznF7MDl8XfVC2aPTas6
	2Tw2L6n3OPhuD5NH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZfS/m8tecEugYvqM74wNjCf5
	uhg5OSQETCS2tu9hhbDFJC7cW8/WxcjFISSwlFHi4K8bUE4Xk0Tv4+lsIFVsAmoSnxsegdki
	AsoSV7/vZQEpYhbYxCTx9PM5FpCEsICVRPOUbqYuRg4OFgFViUcdXiBhXgFNiavrjoKV8Auo
	S7zb9pQJxBYVcJX4tHAjO4jNKWAs8erbVDBbSKBc4lzbXSaIXkGJH5PvgfUyC9RI7G46wDiB
	UWAWktQsJCkIW16i43IjK4StI7Fg9yc2CNtWYt269yww9qKbm1DUL2BkX8UomlqaXFCclJ5r
	qFecmFtcmpeul5yfu4kREm1fdjAuPmZ1iFGAg1GJhzci0T5IiDWxrLgy9xCjCtCcRxtWX2CU
	YsnLz0tVEuFdpOgQJMSbklhZlVqUH19UmpNafIiRiYNTqoGxMV4uabfwZP0J5zwOLTfVygxq
	YHzJ0qnykLPtEZNI+PsVai8Pbeif8767rkeO8xDXsqbltwUENtQ7VOdnn2szmDH9YZrLzt1t
	C7bzKl2VSxV94p14bZ3wl76DP8T66ss2ML5Y9mThs1pOfz/GtFmesuL7FR/O28ko0slmzmkf
	4VJz95fCx2olluKMREMt5qLiRADqsLoMoAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart5657219.y94VlvC6mD
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Mark,

On Monday 23 of September 2013 14:50:42 Mark Brown wrote:
> On Mon, Sep 23, 2013 at 11:45:45AM +0200, Mateusz Krawczuk wrote:
> > Add compatibles for s3c6410, s5pc100 and s5pc110/s5pv210 boards.
> 
> >  static const struct of_device_id s3c64xx_spi_dt_match[] = {
> > +	{ .compatible = "samsung,s3c2443-spi",
> > +			.data = (void *)&s3c2443_spi_port_config,
> > +	},
> > +	{ .compatible = "samsung,s3c6410-spi",
> > +			.data = (void *)&s3c6410_spi_port_config,
> > +	},
> 
> This is missing s3c6400 and at least one other s3c24xx I think.  They
> can be added later though so applied, thanks.

I think after this patch the table lists all the SoC variants supported
by the driver, at least it's what I can tell from a quick look at
s3c64xx_spi_driver_ids[] array.

The compatible for S3C64xx should be probably called "samsung,s3c6400",
though, as it's the first SoC with this variant.

Best regards,
Tomasz

--nextPart5657219.y94VlvC6mD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAABAgAGBQJSQEpIAAoJEIv3Hb8G/XrulM4P/1FIUNOQh25SYRWzfAcdTsCc
qxPWnRKb4TQ+sYBHSGi7YGadLgOgGmDILdQFzDzOB1ANEmqvKCD/xhYSzNKYSjju
hQTM/biX5i/qqdaZ6pedrXlnE+QBBcVvPJ5Wq5aGtJNAtegHyARvVDQU/rQK0Ake
wbqsd5QJbQHgvVtoKKeY/GFqYk9aLOzWUpHkbwg2gzy2Pb4gPqk4HJGRwH8xoEdY
1t6qR7gKDiCgnjO1I4QTTZjuCwE+l5aWhXq49aSo/T+BryEF7qDaY3As31m86QI4
m06SnXiaUvem7H/hpIw9v4STy7Vy9IqQvFY5kSkmRGvXsoIw+0aDmhA4azpohAKn
buccNWXlhkIK8p21O3RwykIUGcE2hCioMkpKvvrytOSQEwKqOA5E0FO1u8/AV5RG
vIOOjLkAAnasdlspC3WiWcVfNsTzon8U226Xbs9zV/fyFK7Byq8H0g+/29BWzVs9
3oVyxMNyVUnB99EUIQV3cG4xqERgOGeMdEhAzYfzPTCB1mhzBJX+yVUB+6IpLnbL
9tLmaXFNLWDS67BpIYcJrbMl8kJ867DIFgJ69xg95RLGgfAbZxFg7G+okwKFrld6
pbPOJjeYSMYmVDOINgrAQ48DgTm1A6NRpfoHvIaKEdEbRYTwtMlDmLebPe5oysoB
Z9ND2tR5pebkaDBufjl0
=taVC
-----END PGP SIGNATURE-----

--nextPart5657219.y94VlvC6mD--

