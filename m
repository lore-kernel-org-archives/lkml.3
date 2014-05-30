Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbaE3Fml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 01:42:41 -0400
Received: from ozlabs.org ([103.22.144.67]:42411 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaE3Fmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 01:42:40 -0400
Date: Fri, 30 May 2014 15:42:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Boyer <jwboyer@fedoraproject.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86,vdso: vdso build fixes and improvements
Message-ID: <20140530154229.46d76630@canb.auug.org.au>
In-Reply-To: <CALCETrVSG7-=Q3sG87YTzDYOLXzEbkvW9Ws=HeJ5cAUGxQhdJA@mail.gmail.com>
References: <CALCETrXef77JLoEp5hCXSdMAk7usWsL-sUG6NrcgLgrz3krfag@mail.gmail.com>
	<cover.1401400316.git.luto@amacapital.net>
	<5387B7A0.3030302@windriver.com>
	<CALCETrVSG7-=Q3sG87YTzDYOLXzEbkvW9Ws=HeJ5cAUGxQhdJA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/y94dlTZ9sNMWjXwc2hGMR8h"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/y94dlTZ9sNMWjXwc2hGMR8h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andy,

On Thu, 29 May 2014 15:49:52 -0700 Andy Lutomirski <luto@amacapital.net> wr=
ote:
>
> On Thu, May 29, 2014 at 3:41 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
> > On 14-05-29 05:57 PM, Andy Lutomirski wrote:
> >> Patch 1 causes make;make to behave similarly to make if vdso2c fails.
> >> Patch 2 hopefully fixes x86 crossbuilds on big-endian machines.  I don=
't
> >> have a big-endian machine to test on, though.
> >
> > Since the x86 builds are unconditionally failing as-is now in
> > linux-next, perhaps Stephen [Cc'd] can layer these on the top of
> > the tree he'll be making within the next couple of hours to give
> > them a big-endian test.

I added them just after the merge of the tip tree today and will keep
them there until they (or somo other solution) turn up some other way.

> Stephen, if you do this, could you also send me some of the build outputs:
>=20
> arch/x86/vdso/*.so.dbg
> arch/x86/vdso/*-image-*.c
>=20
> I'd like to verify that the output is correct.  It would be
> unfortunate if the cross-built kernel had some subtle error.

OK, I will send them in a separate email.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/y94dlTZ9sNMWjXwc2hGMR8h
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTiBpNAAoJEMDTa8Ir7ZwVVZMP/3+Cwi1YerdqEs3Za3c8IqYI
zL8SRqKosi4XFGDADUUwx8pzNKiTSFZtoehP6w6XfN0EJ5sasXY61CricXSCFSUG
gxABVzkmLSIC0wxSwABHAQ3OtA1AyOrvZZXW8smI3cO18G79rfUOlgNf3chHL1MM
kuFKN6a11ssbRIRVAvpfyP9FbcgJHf+5EGu2MqLEXgLSpWmLdwSPQ6OZl8KqluOX
QZKp0QIvZQxtRa66+U/0RKEVDpV5AyJW9CshK+QnnFSoKtrF5rMvT7AO5TAErr9D
+F6+ya+/FYResExeNGBsReSngjjNiPZcQdN/1eUZSGq9ziK0T555CdUX0cHSMvqD
5b2fTNSnz4AWFcvkuBA5q6WIMyxFcRVQQxGpqyWsKngYttMirMCm5BK/yhPWo9U+
3u7fzi8CUVv08pI7daofffj5U7EfhnhivS9m6TmTYoiz+lnB/JDM45y8UVNDYKF4
ki3WPZmUCSQebOH8CixXE/LoP+p8U9chcYkEPZehYo6oeVTg2YllSTvRfDXfJgae
mqyK7wp7cGhr5wuVu99BgItsskvCIfh1KTaBeiQPfxLNui3GkNZCNDhepyjgkqc8
AKFPjSWlG7uCVS9+ZM4NjIdPiGpkhljHktu3UYV1eMFjWnF3Q+lh8JUAX7qDoWKg
jLnDfMwk9YzC6XAFv39c
=rjLQ
-----END PGP SIGNATURE-----

--Sig_/y94dlTZ9sNMWjXwc2hGMR8h--
