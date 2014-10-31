Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbaJaSTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:19:41 -0400
Received: from sauhun.de ([89.238.76.85]:47275 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbaJaSTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:19:36 -0400
Date: Fri, 31 Oct 2014 19:20:37 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 1/3] of/irq: Export of_irq_get()
Message-ID: <20141031182037.GA2680@katana>
References: <1414677578-27412-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1414677578-27412-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <20141030141644.GE23852@katana>
 <2139081.L8ZrMAojpq@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <2139081.L8ZrMAojpq@avalon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 04:17:19PM +0200, Laurent Pinchart wrote:
> On Thursday 30 October 2014 15:16:44 Wolfram Sang wrote:
> > On Thu, Oct 30, 2014 at 03:59:36PM +0200, Laurent Pinchart wrote:
> > > The function will be used by the I2C core which can be compiled as a
> > > module.
> > >=20
> > > Signed-off-by: Laurent Pinchart
> > > <laurent.pinchart+renesas@ideasonboard.com>
> >=20
> > I think it makes sense if I take this via I2C to get the dependencies
> > for the later patches right?
>=20
> It would be easier, yes.

Oh, DT maintainers are not on CC. Then I can wait pretty long for an
ack ;) Fixing that.

>=20
> > > ---
> > >=20
> > >  drivers/of/irq.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >=20
> > > diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> > > index 1471e0a223a5..0d7765807f49 100644
> > > --- a/drivers/of/irq.c
> > > +++ b/drivers/of/irq.c
> > > @@ -405,6 +405,7 @@ int of_irq_get(struct device_node *dev, int index)
> > >=20
> > >  	return irq_create_of_mapping(&oirq);
> > > =20
> > >  }
> > >=20
> > > +EXPORT_SYMBOL_GPL(of_irq_get);
> > >=20
> > >  /**
> > > =20
> > >   * of_irq_get_byname - Decode a node's IRQ and return it as a Linux =
irq
> > >   number
>=20
> --=20
> Regards,
>=20
> Laurent Pinchart
>=20

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUU9L1AAoJEBQN5MwUoCm29PMQAJJWECr0ojCaJbmIa9Ow+rrf
9OPT4nOA2aq43w97OPkFK1RofWpt5XLed2X2KHsouUrNjWj+QuIzGzzwsbV0wQap
UMo+Vrt++dUicYqE4AYkgJz4Qi3aeRXdcJEqviCHT10FlLvedrif9vb218Kq8xE/
jzCLvF79LtpnlGbgDsecd3/lJX0m5Y9z3/hhwrvXD8YLq10WDsqj6GyDdB1BEdRR
9oSWuqbY0prB2UY7Ivk+xR183Fwi/H/l9Q0pFXPYtzy40XbOmAOsXOkByIiMbgQ1
Y19akE1/tp3EqBC3GpVPznVUVIq3ee3wYhBJl6Q7PgsQOMGXvbfJMSuve2iIYoas
+t+BxiDa1UksD7+VmJEajtIKleQ1KyX51OeC3DM7XprLcI7LmIQ9+P4DKtXUvccU
kW2fhiHtajdhp2iIyy6fNQdPkBEdZ8vLLUfzoMsgqKsrgoRBsR/cttv94bg+Mw5b
K/QzeuaEEd164pOZzGO8Fl4rtR4We2dXKSbf2aRF/KPyi/Ibc4ghaz19j28E9HZG
v66YTC2M0bJDY9u3+mnRl3xxn+e8TK5Dl3O6THWXcJ/QAfl42qddqDkMfwG2XQiP
MBERcqWl4hxU28OEAy6Ib5whPhBRd009CCf25EqBobJCFp2+eh54D8TUCUwSvkbl
8DzbyAzTukQQHPr7tCdv
=BkhY
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
