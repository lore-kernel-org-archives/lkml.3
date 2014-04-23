Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbaDWJ5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 05:57:45 -0400
Received: from ip-78-45-166-173.net.upcbroadband.cz ([78.45.166.173]:55891
	"EHLO moskyto.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaDWJ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 05:57:43 -0400
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Apr 2014 05:57:42 EDT
Date: Wed, 23 Apr 2014 11:48:36 +0200
From: Jan Moskyto Matejka <mq@suse.cz>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: fix documentation for /proc/stat, line "intr"
Message-ID: <20140423094836.GA10953@moskyto.dyndns.org>
References: <1398180580-8089-1-git-send-email-mq@suse.cz>
 <5356B2AB.3020005@gmail.com>
 <5356EEBB.5040402@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <5356EEBB.5040402@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

n Tue, Apr 22, 2014 at 03:35:39PM -0700, Randy Dunlap wrote:
> On 04/22/14 11:19, Michael Kerrisk (man-pages) wrote:
> > On 04/22/2014 05:29 PM, Jan Moskyto Matejka wrote:
> >> The sum at the beginning of line "intr" includes also unnumbered inter=
rupts.
> >> It implies that the sum at the beginning isn't the sum of the remainde=
r of the
> >> line, not even an estimation.
> >>
> >> Fixed the documentation to mention that.
> >=20
> > I'm not really doubting what you claim, Jan, but it would be really
> > helpful if you provided some data to support the proposed change
> > (Kernel source references, or notes about testing you've done, or=20
> > pointers to mailing list threads, authoritative note that you are
> > the maintainer of some relevant kernel subsystem...). Do you have
> > something like that? (It's also useful for the change log.)
>=20
> I wouldn't mind more of a changelog, but the additional text is
> certainly correct.
>=20
> Thanks.  I'll apply the patch, but more changelog comments are welcome.

Thank you for applying.

You may add following line to the changelog:
This behaviour was added to /proc/stat in commit a2eddfa95919a730e0e5ed17e9=
c303fe5ba249cd.

MQ
--=20
Jan Mat=C4=9Bjka <mq@suse.cz>
SUSE Labs

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTV4xzAAoJEDFERKcRJ1apSP4P/0lJSjumwBGRlU59f/dMbypi
UiGxH0OP2mUMAXRnwEEhVzNjzXRddRTRxI0w6x6cKFf8PnRNtutov+EVJMMyeYDF
bwzb9OkazQVHbt0TkzjN+hVyoO5+BcNRxbnsadz87mMs8ttHkrwPysI7A1+2Vn/a
P6Fv5zzxnGKftYKv1sFCCa6oUS2CPT1mDRNVyJea1XoZ30dJT/wNj2rKuqH82Vca
1Xluqaa2h/QSKiv5YxSRdfAdlQC9wKslV4eQsS0612J4j0PWSYNCxeDbl+WLH08s
8sXGueCCw+ilWUeYhjSLlx4sgeBVd7GVM6m0zJVoL+XNjTZhpVCWmvG2K2zAyFVg
ZrV7JT08QJpNwxAwynJ6Jc7hTHJKiEt42RE884Xd9xBWHgHpRXdf8NV2YdAZZ7EL
RJUc2U7YY/5C1/ml+QY61g6hQCFzuLsNl7SI4qsH8mffUGXR2Tzl5ij6eoA9jHaY
9iOLNaSAVjkYCcJSCw8WN2UirSxgyXbd6X5vH9z/JPjprgMfRrwmyoZfkli05eL1
wkUpfr3iX5nN4RdsnNRjtxD19aqKUeF6B1aAcmQTx9UcDJMrULkinjg7RsMuGHEf
i0gesbSMceYL1SgyiXTW7yAqNY3gKW1gVWjIiSyhZ0HkDhaL2ZmtQMzg4Xbu6Pk0
8fZ1oW+U91zi/WZoJiAH
=YbSc
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
