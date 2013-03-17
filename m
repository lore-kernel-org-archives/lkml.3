Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab3CQDn6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 23:43:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53597 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755435Ab3CQDn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 23:43:56 -0400
Message-ID: <1363491758.3937.239.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2] iommu/amd: Initialize device table after dma_ops
From: Ben Hutchings <ben@decadent.org.uk>
To: Joerg Roedel <joro@8bytes.org>
Cc: shuah.khan@hp.com, iommu@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, shuahkhan@gmail.com
Date: Sun, 17 Mar 2013 03:42:38 +0000
In-Reply-To: <20130303225828.GA22602@8bytes.org>
References: <1362087590.2822.44.camel@lorien2>
	 <1362265235.3768.156.camel@deadeye.wl.decadent.org.uk>
	 <20130303225828.GA22602@8bytes.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-WPbVFvloCwtPcxK4NBQz"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WPbVFvloCwtPcxK4NBQz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-03-03 at 23:58 +0100, Joerg Roedel wrote:
> Hi Ben,
>=20
> On Sat, Mar 02, 2013 at 11:00:35PM +0000, Ben Hutchings wrote:
> > I'm not convinced about this backport, because the order of
> > initialisation already changed a lot after 3.2 and before the upstream
> > commit.  So I'm going to wait for Joerg to confirm that this makes sens=
e
> > before adding it to the patch queue.
>=20
> The patch looks good, it fixes a race condition during amd_iommu
> initialization. I'll also gave the backport a test to be sure it
> doesn't break anything.

Applied, thanks all.

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-WPbVFvloCwtPcxK4NBQz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUU7rue/yOyVhhEJAQrSfg/9HdiIdudy3NnPDqaENUElXOipOIYN3VIj
9aQLvrGXAsBM7yGT5StWZupYMCXUpkpXveGMV1v7Vy1ncnXb37wf9a98F8B6mSsU
UWNVSN8fQaz4J++y8sVIiZYiGEqF8cshSvLLVpHTozQrtCZ0JxijAeazhLObfNTz
g2IAKINJ15TBDhn6f3snZxAJO3g3wzW/7aBpjlEztkTvm4zOVziWmuVhhDLTyZh5
3DDgMvgtoQ2mW9x4UG0vefp3dwQ5VrfOtFcw/e7J47q6aotseIRQ1HkZd4xvX6Pt
hYnQLdWS58IfAnv0hkaO8DJPqyiXGOE8Xq32uNwIdzCuRYqJyh4f6FhDmOi2O3gB
xft4+UBkRPoJr4emEmcZWPoHxjN/k2bKALtW/BRuNQsvOkojlwBDu0bswVhXrR3y
S1BT3elILYI+ZhLkEeyB1K+GabSEUDE2SWhM4Kq4hs/T0HalIheocUeavEYK0X+4
8ChoeDNAD2vi8nCsEZvssvznk1KTBrmvfv/Mh3rAV2kUeUdDeMFmliGBdqw5kl8G
QqDsDqurHW24EtwFrFP01HOVTfYzp8qEfb29iTbDKpVNi4kJdlT5QESiT2oWG1du
tFHePFmMvkjYXnxaxypxObZ4C4mYz1bqd3JIxUkIuwzGHnRabNn8JAUChCeCWeRg
bN72eDYl5YQ=
=MrJG
-----END PGP SIGNATURE-----

--=-WPbVFvloCwtPcxK4NBQz--
