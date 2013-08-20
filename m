Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab3HTTbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:31:37 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:60291 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3HTTbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:31:35 -0400
Date: Tue, 20 Aug 2013 21:31:31 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Julia Lawall <julia.lawall@lip6.fr>,
        kernel-janitors@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] PCI: tegra: replace devm_request_and_ioremap by
 devm_ioremap_resource
Message-ID: <20130820193130.GA14170@mithrandir>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376911241-27720-2-git-send-email-Julia.Lawall@lip6.fr>
 <20130819120249.GA5740@ulmo>
 <alpine.DEB.2.02.1308191405450.2313@hadrien>
 <20130819121238.GB5740@ulmo>
 <alpine.DEB.2.02.1308191414360.2313@hadrien>
 <20130819193339.GB4961@mithrandir>
 <alpine.DEB.2.02.1308201112400.2269@hadrien>
 <CAErSpo4WLt7zbyfkKfvMbXMQGmp0MAS=7AFiomUjtUCfdprDUA@mail.gmail.com>
 <5213BB2C.60908@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <5213BB2C.60908@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 20, 2013 at 12:53:32PM -0600, Stephen Warren wrote:
> On 08/20/2013 10:26 AM, Bjorn Helgaas wrote:
> > On Tue, Aug 20, 2013 at 3:13 AM, Julia Lawall <julia.lawall@lip6.fr> wr=
ote:
> >> From: Julia Lawall <Julia.Lawall@lip6.fr>
> >>
> >> Use devm_ioremap_resource instead of devm_request_and_ioremap.
> >>
> >> This was done using the semantic patch
> >> scripts/coccinelle/api/devm_ioremap_resource.cocci
> >>
> >> Error-handling code was manually removed from the associated calls to
> >> platform_get_resource.
> >>
> >> Adjust the comment at the third platform_get_resource_byname to make c=
lear
> >> why ioremap is not done at this point.
> >>
> >> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> >> Acked-by: Thierry Reding <thierry.reding@gmail.com>
> >> Tested-by: Thierry Reding <thierry.reding@gmail.com>
> >=20
> > I'm hoping this goes via arm-soc.  Let me know if you need me to do
> > something.  If you need it:
> >=20
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>=20
> In that case, Thierry, can you please bounce it to arm@kernel.org to be
> applied on top of wherever Tegra's for-3.12/soc branch was merged.
>=20
> Acked-by: Stephen Warren <swarren@nvidia.com>

Yes, I can do that. Thanks everyone.

Thierry

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSE8QSAAoJEN0jrNd/PrOha7cP/jHHviDSOEEdhLvAlWNYXNIA
YZeqSc3FoIx0oYpfA0gJqrBI7TUKExYMgRB6pX64UObkql/p14MPI39Fwy0BSmIM
YThoFDC8sPvbCdaHCc5EDaxxQVysgg39/lrmJcccQRKxJdPTiEvkzPfyQoxex/hY
uMu1K49oGWZc7uSf/JYvPLo/C4YC1jPnxuvWi3BEtgUJcWfjH9YjDxT6OdUTcGY3
AA5GQ/1fC81s+QjWtkqz9rQYylTTqW7kCXsdf8UCJoVYNcP6P3hCtD3K6eIVSBoa
JKC0Rbgp4s6kDH21XcRfrSzODMKMBS903QZ403HltDiZJ7GV/lzvtIduFE0zT2Y+
4bZuz8z17dkkLVWQ64VnSHv6mkT7hY5nR6fIbBsdaX02za2BqRSshPa/fkki1V82
Z5kAGFF4wnMRJfylvu6Min5mNx/YA7eUll66h/02ZYG/piKSEJvvL5ERosbxDkNw
aZoYye2jUcpdFCd7RmfNbfgLEo/KKOMxLlUSYeizYeeIQqFNOJLtWbPRt6zliXVg
la6RMrEcIBxSQm9Fba067gQJKlsMmmGTxjZvn56PEfzJBpJ89NY4gn3LiVUG8p/w
ilgualt13rvm7EsgGBtOhHpM+Z9JGiPv1lgn4vTJ50Bl5Rc+v2CxDbnw3CT73nfi
5ruM8fJ8Db/OHwOY56I2
=S6/L
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
