Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaLUT42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 14:56:28 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:43342 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbaLUT4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 14:56:24 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v4] i8k: Autodetect maximal fan speed and fan RPM multiplier
Date: Sun, 21 Dec 2014 20:56:21 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
References: <1419153618-6930-1-git-send-email-pali.rohar@gmail.com> <201412211940.06980@pali> <549716A7.2040207@roeck-us.net>
In-Reply-To: <549716A7.2040207@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5400712.nIu90p5WvV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412212056.21529@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5400712.nIu90p5WvV
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 21 December 2014 19:51:19 Guenter Roeck wrote:
> On 12/21/2014 10:40 AM, Pali Roh=C3=A1r wrote:
> > On Sunday 21 December 2014 19:27:34 Guenter Roeck wrote:
> >> On 12/21/2014 09:23 AM, Pali Roh=C3=A1r wrote:
> >>> This patch adds new function i8k_get_fan_nominal_speed()
> >>> for doing SMM call which will return nominal fan RPM for
> >>> specified fan speed. It returns nominal RPM value at
> >>> which fan operate when speed (0, 1, 2, 3) is set. It
> >>> looks like RPM value is not accurate, but still provides
> >>> very useful information.
> >>>=20
> >>> First it can be used to validate if certain fan speed
> >>> could be accepted by SMM for setting fan speed and we can
> >>> use this routine to detect maximal fan speed.
> >>>=20
> >>> Second it returns RPM value, so we can check if value
> >>> looks correct with multiplier 30 or multiplier 1 (until
> >>> now only these two multiplier were used). If RPM value
> >>> with multiplier 30 is too high, then multiplier 1 is
> >>> used.
> >>>=20
> >>> In case when SMM reports that new function is not
> >>> supported we will fallback to old hardcoded values.
> >>> Maximal fan speed would be 2 and RPM multiplier 30.
> >>>=20
> >>> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> >>> Tested-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> >>=20
> >> Tested-by the submitter is kind of implied.
> >>=20
> >> Anyway, this patch does not apply to 3.19-rc1, nor to 3.18.
> >> What is your baseline ? Can you rebase to 3.19-rc1 ?
> >> Or do I need to apply some other patch first ?
> >>=20
> >> Thanks,
> >> Guenter
> >=20
> > You need to apply these old patches:
> > i8k: Add support for temperature sensor labels
> > i8k: Register only temperature sensors which have labels
> > i8k: Return -ENODATA for invalid temperature
> > i8k: Rework error retries
>=20
> I think it would make sense to re-send the entire series at
> this point (including my patch and all Reviewed-by: tags).
> Problem is that not all patches have a version number (for
> example there are multiple versions of the label patch, but
> the version I reviewed does not have version information).
> This makes it very difficult to find the correct (reviewed)
> version, and I suspect that Greg may neither have the time
> nor the desire to do it.
>=20
> Thanks,
> Guenter

Ok, I sent all patches which was not merged to char-misc tree yet

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart5400712.nIu90p5WvV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSXJeUACgkQi/DJPQPkQ1IvZwCdEkhnFAud/dtTKpff/dq8njgP
dcgAoM2ptTikOnoBRnWdk0+mh4J2b8mJ
=MZUK
-----END PGP SIGNATURE-----

--nextPart5400712.nIu90p5WvV--
