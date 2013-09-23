Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3IWUwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:52:07 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:35132 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3IWUwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:52:03 -0400
Date: Mon, 23 Sep 2013 22:50:39 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 5/9] of/irq: Introduce __of_irq_to_resource()
Message-ID: <20130923205038.GD5216@ulmo>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
 <1379320326-13241-6-git-send-email-treding@nvidia.com>
 <5237782B.3030804@gmail.com>
 <CACRpkdadFct8iXSaRRQ3a2YQryfMjJwVaq+8wgWXS1Ymj3M_WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u65IjBhB3TIa72Vp"
Content-Disposition: inline
In-Reply-To: <CACRpkdadFct8iXSaRRQ3a2YQryfMjJwVaq+8wgWXS1Ymj3M_WA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u65IjBhB3TIa72Vp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2013 at 09:20:37PM +0200, Linus Walleij wrote:
> On Mon, Sep 16, 2013 at 11:29 PM, Rob Herring <robherring2@gmail.com> wro=
te:
> > On 09/16/2013 03:32 AM, Thierry Reding wrote:
> >> This is a version of of_irq_to_resource() that propagates the precise
> >> error code instead of returning 0 for all errors. It will be used in
> >> subsequent patches to allow further propagation of error codes.
> >>
> >> To avoid code duplication, implement of_irq_to_resource() as a wrapper
> >> around the new __of_irq_to_resource().
> >
> > I think the callers in this case are manageable to update as well.
> > Several cases could simply use irq_of_parse_and_map instead as they just
> > pass in a NULL resource.
>=20
> I second this comment.

That should be fixed in v2 of the series that I posted a few days ago.

Thierry

--u65IjBhB3TIa72Vp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQKmeAAoJEN0jrNd/PrOhpsYP/2xzs3k69Qi+gWUntP1If6vS
9gqRbcx8LT4ESsT94HHYieEF/P821YGLviE3Hi3LRSCZwR8mEYmFXHdf24Y4Z6wC
zexH3VxggvAe6RtDx5I8+0vyia4UV8N5Hx3xBqPkBRsQYIdMkEf5mCjqfs71RntT
kQu4jCeaznIiMMn18YkqwpJqHuCeHn3u6HmuKn1xSEbxcf8etXEE5bANehkdPyNO
7E7NTSDrmCnXhwJRlALlAee1TmEaV8TmF7mYtVM3QmjP+PX7hkSk6rbJ08XuWUCS
DCOiOMTuGlyRkRVJZJiWQO/ajmZT5bWXMUoOzYuV5RzDsUzbQjw9oFEbzs6ww5zi
7CtHnlNS3r98BDMb+jk9+CJ55xm0+BIyhuq540Dmn8nGuV50LniQF0ViHTBc9JBQ
vQA+I5PtruaiJbDokA8KVn+Q7VbPStSMgvrUuPOQudVJICfUvsc3df81BVAgD4zW
kZzBOVtb+PZwNFyYC5u8Dnx9yJqjQebkOccYYKESI1RzJW9YSPtMGe/XXZmqNsVG
pHI196XlHrih3fbPKD6J1unERKfmDcXswYtcU2NJNMeMCjlBDq+PJZLsbc2mwL/l
aGhf2Wx13qqHid+cBo7P75/frWEQU/wpUKugLCGs7UeFYKk/D3Ofr4BeRDYMAr0K
Geb6Q+K8bx8LJGDUpDKG
=gApM
-----END PGP SIGNATURE-----

--u65IjBhB3TIa72Vp--
