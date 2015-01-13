Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbbAMPm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:42:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50624 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbbAMPmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:42:55 -0500
Date: Tue, 13 Jan 2015 09:42:05 -0600
From: Felipe Balbi <balbi@ti.com>
To: Peter Chen <Peter.Chen@freescale.com>
CC: Huang Rui <ray.huang@amd.com>, Felipe Balbi <balbi@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: gadget: u_uac1: fix build issue
Message-ID: <20150113154205.GC16533@saruman>
Reply-To: <balbi@ti.com>
References: <1421130034-1891-1-git-send-email-ray.huang@amd.com>
 <BN3PR0301MB08491E88100625CCAE38DAE781400@BN3PR0301MB0849.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
Content-Disposition: inline
In-Reply-To: <BN3PR0301MB08491E88100625CCAE38DAE781400@BN3PR0301MB0849.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 13, 2015 at 06:51:40AM +0000, Peter Chen wrote:
> =20
> > See below error message:
> >   CC [M]  drivers/gpu/drm/nouveau/core/subdev/vm/nv50.o
> >   CC [M]  drivers/staging/lustre/lnet/selftest/module.o
> > drivers/usb/gadget/function/f_uac1.c: In function =E2=80=98f_audio_free=
_inst=E2=80=99:
> > drivers/usb/gadget/function/f_uac1.c:904:21: error: =E2=80=98struct f_u=
ac1_opts=E2=80=99 has
> > no member named =E2=80=98card=E2=80=99
> >   gaudio_cleanup(opts->card);
> >                      ^
> > make[4]: *** [drivers/usb/gadget/function/f_uac1.o] Error 1
> > make[3]: *** [drivers/usb/gadget/function] Error 2
> > make[2]: *** [drivers/usb/gadget] Error 2
> > make[2]: *** Waiting for unfinished jobs....
> >   CC [M]  drivers/staging/lustre/lnet/selftest/ping_test.o
> >=20
> > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > Cc: Peter Chen <peter.chen@freescale.com>
> > ---
> >=20
>=20
> Oh, my three patches have dependencies, it needs to rebase Felipe's
> fixes tree to fix this problem.
>=20
> commit 4fde6204df052bb89ba3d915ed6ed9f306f3cfa1
> Author: Peter Chen <peter.chen@freescale.com>
> Date:   Mon Dec 1 16:09:27 2014 +0800
>=20
>     usb: gadget: f_uac1: access freed memory at f_audio_free_inst

Yeah, once that gets merged by Linus, I'll merge v3.19-rc5 on my next
branch, that should sort it all out.

This is one great example of why you should never make new features
depend on fixes. We will always sort out the merge conflicts later.

--=20
balbi

--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtTzNAAoJEIaOsuA1yqREs90P/1uV6zw4ujCcsc/RuzfdlC8Y
Yk5UZykIHZaLgMa1icTSx3VlfVfg543d/jOztNxMj4CIkhkHq0IIw5gvzYCwAo9E
HRjNEAvxGwm2Rjd8xMHj2dUtrPUyRO0cOVNQe6OsfTtnSydw3VfLKPfblOrLev4T
TAdKxeU59a6sjeR4aCcc9kGz7p5PBehwFojm+BGW1LiF6j0tCjjL0KNn7vlZT+c7
aOokNMzLdGC6BEWbnh1KAG5id9fG8OynDBJ5IBT8kZJHXuQwSocQscH5qxcXm/NA
Euc4bKIK1X+4UkVWNupno6arqfm1SBYtIdGvGT85hY8l5C23ubCVTM2VhiaFN3iF
NbB0LMog3H+7/6IJZGi8MwO+5Qo1kz9iMUKPM+RRcTpkQk5tFpH1T8NcFoPea22K
JnStCaDyGdDOD4u9Y+eYHabd0hns4IJi8JocRbTt+6HOxZM4ZAWa30GKVooYJn7Y
LPLiS1Jt/RM3VSQuQTF5CSDAq9fPnCU3+64MEoydWVcJY0N+sPFAnx2AA7SW0Xmy
ezssmEb5Btwefj0u/JXhasTxRGU1yXqz5T4SLb2MJmwlrbmbjVGTtfjoMaE6Op1J
FIoPcRzrhjdtGXxJD/Im+2AL/1865JOsZEy8NO+DgZpCISWUnHILVNZKIfItkRv5
SllXMU3t9/UuI7nPknWL
=IXLN
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
