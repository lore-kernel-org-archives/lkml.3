Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaCJShz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 14:37:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37508 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbaCJShx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 14:37:53 -0400
Date: Mon, 10 Mar 2014 13:36:11 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, Tim Bird <tbird20d@gmail.com>,
        Kumar Gala <galak@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v5 00/14] usb: phy: msm: Fixes, cleanups and DT support
Message-ID: <20140310183611.GB32363@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394014430-26485-1-git-send-email-iivanov@mm-sol.com>
 <CA+bK7J5ABQ9WcSKkLf=DfTEv3xb_ZKDYgjHTqwLbapYr63ivxQ@mail.gmail.com>
 <20140308001553.GA26170@saruman.home>
 <531B497C.1000408@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
In-Reply-To: <531B497C.1000408@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Mar 08, 2014 at 06:46:52PM +0200, Ivan T. Ivanov wrote:
> Hi,
>=20
> On 03/08/2014 02:15 AM, Felipe Balbi wrote:
> > On Wed, Mar 05, 2014 at 05:54:03PM -0800, Tim Bird wrote:
> >> Ivan,
> >>
> >> I'm still unsuccessful at getting this patch set to work on my kernel.
> >> See regs in dmesg log
> >
>=20
>=20
> <snip>
>=20
> > never got any reply to this, nor got a response to Sergei's comments.
> > Not looking good, too late for v3.15.
> >=20
>=20
> I am working with Tim to resolve this issue. Sergei's comment have
> been answered already :-)

the only answer was "Thanks I'll fix it". To which there was never a
fix.

> It will be nice if you could pick up first several patches, which are
> just cleanups.

unfortunately I have already sent my pull request to Greg :-(

I could try to get some of those in during the -rc cycle, but it's
unlikely Greg will let me :-)


--=20
balbi

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTHgYbAAoJEIaOsuA1yqREKmAP/0Hz/W2OViQ++jHsc0ilVtFE
Px6USvPrB8WZRDQrhnXEUYmuv1YWUmlz35MgR5Bew+gNaiD2zqJuGernIdgMpi1Z
PpbSX3vfMR9icu4kAXcnqdaae43EU71FzwZHCDor1roMdRROsGXVAsgXGuMUDodA
5GtlFI84zAiKO9QAl/gS3JYtOz9JTOxLIijfygzPsu0xVexGfO3Z9XUoRI1VW792
JCXtqVzhb15/fsWDeww+IsudDly6zphGLfKvZqg2iZ1den5QV9loxixCG4q29Utk
vA0He0fMycrLrgutBPIm5A06jWCT8SKRaWArbdvShe9WRb5kDJxYE1cn0edczaw9
wiR5IRMG2Gie0/DsEe66rOBLZyNfpxBdbBOXL2xeLs1LJ7LUjTXuvMv56x34ZYZ/
08RUSdQAf9LzcQdXIj0491AZWFllrYOJrnOA14LoN0G26yTc9N+4zBaIM29n2ndn
2/Wo/C3rAbHDbUVRqHRhWyGLaE44c3Eb+zdbJt2l4/+z2OTRMgMiiLf8cQI2G+hT
978vlTejS0VBG3Moj5As5XO1aQwo3rC1cgIvn5prkf/wpXWNFVvBQDWesIqHS/Sw
Wa+mpE/Py+3eyvQC2SA381enbDlFdDy5LhB3kCrVKMpgN+JEzkoSoMec7TF0/F6/
RgNHJLdkmx8nudoeKW9s
=QCT1
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
