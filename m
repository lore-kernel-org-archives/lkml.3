Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553AbaIRRMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:12:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35242 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932277AbaIRRMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:12:35 -0400
Date: Thu, 18 Sep 2014 12:12:26 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@ZenIV.linux.org.uk>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: linux-next: manual merge of the usb-gadget tree with the vfs tree
Message-ID: <20140918171226.GE4537@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140917161658.2e4eb3f1@canb.auug.org.au>
 <20140917153400.GA8140@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
Content-Disposition: inline
In-Reply-To: <20140917153400.GA8140@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 17, 2014 at 10:34:00AM -0500, Felipe Balbi wrote:
> On Wed, Sep 17, 2014 at 04:16:58PM +1000, Stephen Rothwell wrote:
> > Hi Felipe,
> >=20
> > Today's linux-next merge of the usb-gadget tree got a conflict in
> > drivers/usb/gadget/function/f_fs.c between commit 8322215aa91c ("f_fs:
>=20
> I can't find this commit on linux-usb. In fact, googling for it the only
> reference I find to that commit is this very thread. I would strong
> suggest that it be removed from the tree as it, apparently, went in
> without any review. Sure, it's a simple change, but it needs to be
> reviewed and needs to be sent to proper maintainers.
>=20
> Unless I'm missing something, of course, but I could not find any other
> references to this commit.
>=20
> Al, was this commit sent to any mailing list ?

a gentle ping here

--=20
balbi

--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUGxJ6AAoJEIaOsuA1yqREReYP/RNl4N2ImMaFl0/7GcS6o6OJ
TN9F3zuSFNlNaF7iG8nORttFXkXM2Gtc1q8OVexS7J+bVNMvvCvkOIev3LLjDd3r
WpB3FW1kIQ9zYYzIntdoT/Zm4TDP/FZ8lyz44jMTVsUgFVT3s8igolSvv7P2ObE1
YPHBFdnKo8FgxkEvTzrFkynO9n4J7ZvnOMBwhSSivznErjWLUcIdaLymx0/nmQDb
mFDMP32/XhMDWygMFCYRNtxrfvR7Gs77u6lqzTaS3SBqUNc7w91ftuOYAbIM2o7K
5tmS/F7sRN6GlWsQq4oj7rvtEUS2rh4aPqmFBi5JII9/NiYEKbIc5F903KZlpH62
LSDDs+RiF/3YS5dsGwTAlHkla+f6hHggzzXSanvdWl/hpIj/dqr65RFwQUxH2azf
YUyZ1yp4bYaFnoTWXtqjT5BN2s23cpKC4DU12viZmMraEvzW4SAmRps5v+2eL9ga
CjhGTVRlmMTsQfT12qmO1Y+Rexp1iV9odbY5kY/Fg+egQ4UMS7Y2URV7xS1Ert5R
SOugLpeC9uGwyzHiHzEtdjk8AhV3/lRn9wyeJkkkQRSEhDzeYkp1f5fSc+R9cTpo
/s0ShKQTTrIs678p8sL6PS5yYOrnhmbFvLL1MIvZImYud7xfLuUd+wzZ97AjSWUS
UMpdjt3X5UiBLeM3Sgh6
=rbo2
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--
