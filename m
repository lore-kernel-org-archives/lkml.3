Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbbASPFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:05:18 -0500
Received: from sauhun.de ([89.238.76.85]:58337 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbbASPFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:05:17 -0500
Date: Mon, 19 Jan 2015 16:05:15 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Eddie Huang <eddie.huang@mediatek.com>
Cc: linux-i2c@vger.kernel.org, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 01/11] i2c: add quirk structure to describe adapter flaws
Message-ID: <20150119150514.GB3820@katana>
References: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
 <1420824103-24169-2-git-send-email-wsa@the-dreams.de>
 <1421387408.9323.10.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <1421387408.9323.10.camel@mtksdaap41>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > +	struct i2c_adapter_quirks *quirks;
> >  };
> >  #define to_i2c_adapter(d) container_of(d, struct i2c_adapter, dev)
> > =20
>=20
> I suggest to add const.
> 	const struct i2c_adapter_quirks *quirks;
>=20
> also, in i2c-core.c, should modify:
> 	const struct i2c_adapter_quirks *q =3D adap->quirks;

Thanks, I'll think about it.


--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvR0qAAoJEBQN5MwUoCm2kAQQAIn4NHdQ77C3iBtOkfdr7nta
VM8Ft7w+0genCuj5Gkse3W92uzfmv6l50ffQH5vDEG+20b0dOTJI05peBler8+hK
hFBE7V5lkx/ujwtuWUhn4wMcnWOXGLnIyTxm7MQCo146ORIp4Z3th5/jR0ACSe40
vTAlbm3sAkZvArbjIeLfSiQY3MNhYjYx/0wPp2u9Tyi+TxHs27bj/bS0Q8Z8xgxA
jMjhHZzFvplwoy8x76FglCx1ZPpgWajLgQQtcz/JXOwmXqlc+jTMbVcgbunEh6w3
F5WYGEM6eUVT5dKvTLdBvaxrcbhGU56tXiX1z54J8A6ZyXipji28CT/8QG0xJt8p
R1I20oHhwd+Fz9ZX0Y1KJthj+2ZkvoKiBTIVcNyJt0KnCQUU+DKslUQELsBn3dO+
vD3r7kL/DHLVFtXLSWMASyzkB6ytANOBCmt5elHoKD10ZOZx9oBbMEUXkH/6MNEK
IPJSdGevkCMsPnDiKcEISk+COYyzFHyPYIu4Gahl5SgpytIyCkWVRTCl4HBpW+e3
Gc0u08W59eDmuzzOqfmYga+EPU6Wr3YIrhtAnagtmrhGP4332L3htI/kHSt2uylE
3TP8XymlY/PcAWwWfbH+R0Wv5nBfUsCTtJgNa4KHhqdr3O0tLyKKf6MfjzSCtFN9
dOAm/x3bZqagrE8Cq8Lf
=PK3B
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
