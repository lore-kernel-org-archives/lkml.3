Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbaHHP7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:59:08 -0400
Received: from ozlabs.org ([103.22.144.67]:37795 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512AbaHHP7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:59:06 -0400
Date: Sat, 9 Aug 2014 01:58:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>,
        Mollie Wu <mollie.wu@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Andy Green <andy.green@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Request to include Mailbox tree in linux-next
Message-ID: <20140809015857.17af92e7@canb.auug.org.au>
In-Reply-To: <CAJe_Zhc+_zCB+7196rsHb=KxG4JyuvyODXCpEX-y4XhwRjoBrw@mail.gmail.com>
References: <CAJe_ZhdZTSs+Ns4u7bMXwbLHYTnE-5XEE8uev4zXbXrCP52bSg@mail.gmail.com>
	<20140808142912.7bf68229@canb.auug.org.au>
	<CAJe_ZhceR1j_b-_efJoq9Dv6X6C=UuMgyp8AofjcCvc+bQVkfw@mail.gmail.com>
	<20140808144137.GE30282@n2100.arm.linux.org.uk>
	<CAJe_Zhc+_zCB+7196rsHb=KxG4JyuvyODXCpEX-y4XhwRjoBrw@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/NEnB67Sc7KUsb8espad3grL"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/NEnB67Sc7KUsb8espad3grL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jassi,

On Fri, 8 Aug 2014 20:40:47 +0530 Jassi Brar <jaswinder.singh@linaro.org> w=
rote:
>
> On 8 August 2014 20:11, Russell King - ARM Linux <linux@arm.linux.org.uk>=
 wrote:
> >> Upon Mark's suggestion (and the right thing to do) I wanted the patchs=
et
> >> to live the cycle in linux-next.
> >
> > Yes, that's the right thing to do, but you sent the request at an
> > inappropriate time.  The correct time to send your request would be
> > after 3.17-rc1 has been released, IOW after the current merge window
> > is over.
> >
> > In general, kernel developers don't "remember" requests from one week
> > to the next; instead, we much prefer people send their requests at the
> > appropriate times in the development cycle.
> >
> OK, thanks for explaining.

As Russell has said, if you remind me after -rc1 is out, I will add
your tree then.  I will try to remember, but don't depend on it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/NEnB67Sc7KUsb8espad3grL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT5PPHAAoJEMDTa8Ir7ZwVfrEP/RNbutbbRXNry71MoOCB9798
e0q5+MS6NTpFLd3wjh1MGjx/Q/M9eWqDiuthFoJKlhew7ACMc78Wuaiqkm/kXDle
k0WNRnfGseTk4xC52NYlNmOEHnBIjH9+1BkTou31g+68i3qftl1wVPU6YkQ9rg6D
rglIHt5O6j9/VIjm+QeArCBuf6naTfxVo5TEQ60SufaFwuU3RnHtre/0/xMYygE9
IYE0jUu0UxVEbC4y1jBuTw7YEm/sgS9/UAGj2Il1odREIH/dHGLlveI1uATs4Sp2
tAgxD8DJhRBvqAbxxeueE9t9TEqE18eKCRGP0IHRUkZ2WhGDWCE4a2X8CxCFOrFH
EJ0vl6qVxA4noLYGGWQ45fXfU78LFt+9FEbABYm+rUDRqdiyOjTPUIgn2A72T2rc
bpHGtIzCxNYwHavIfJyloRwi8w8Ig2pensxszN11cbzlgbTAxU9qTNWj7+w8V13o
Ed6jG1eduvF1SNY4KzP/s6p1pdDSkXDZPxszsZ0ykHKxaTJn1qoRYHiGiLJH1+kh
nan1oW9JSXUE8WgfGXkhiOCtORV6PefZz1RS/+ijr86AK4Hw9J/xdrKc6bi1NTkt
sjbGTw1cu/X+P2liH/tSWoVjL1kXdhTQi88LLaejxPr5Jf3dEnV347rnekbv+80P
7g5G8pnGCOfjOBN/XM91
=kcuE
-----END PGP SIGNATURE-----

--Sig_/NEnB67Sc7KUsb8espad3grL--
