Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaEWG4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 02:56:10 -0400
Received: from mx1.emlix.com ([88.198.240.195]:37716 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaEWG4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 02:56:07 -0400
From: Rolf Eike Beer <eb@emlix.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: wsa@the-dreams.de, rjw@rjwysocki.net, mika.westerberg@linux.intel.com,
        awilliam@redhat.com, lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V2 0/9] I2C ACPI operation region handler support
Date: Fri, 23 May 2014 08:55:55 +0200
Message-ID: <1481506.mZgg6LykyH@devpool02>
Organization: Emlix GmbH
User-Agent: KMail/4.13 (Linux/3.14.3-1.g2a280a3-desktop; KDE/4.13.0; x86_64; ; )
In-Reply-To: <537E143F.7060701@intel.com>
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com> <4867018.HWMf8AlFN3@devpool02> <537E143F.7060701@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1922782.EugPuHskmN"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1922782.EugPuHskmN
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Lan Tianyu wrote:
> On 05/20/2014 10:17 PM, Rolf Eike Beer wrote:

> > It may be that I have taken the wrong ACPI files. This is the resul=
t of a
> > fresh run of acpidump, together with the most recent dmesg.log, jus=
t in
> > case I messed it up.
>=20
> =09I have check the log. I2C ACPI operation region targets to I2C con=
troller
> which has one ACPI node in the ACPI table and is associated with one =
I2C
> adapter. Graphic with one ACPI handle registers several I2C adapters.=
 This
> causes attach data to the ACPI handle with the same handler several t=
ime.
> The ACPICA function will return ALREADY EXIST error code and causes t=
he log
> you mentioned. There is no I2C ACPI operation region under graphic de=
vice
> node and so not break function. To avoid these noise logs, I make the=
m only
> appear under dynamic debug mode in the my V3 patchset.

Hi,

thanks for the clarification.

Greetings,

Eike
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax +49 551 30664-11
Bertha-von-Suttner-Str. 9, 37085 G=F6ttingen, Germany
Sitz der Gesellschaft: G=F6ttingen, Amtsgericht G=F6ttingen HR B 3160
Gesch=E4ftsf=FChrung: Dr. Uwe Kracke, Ust-IdNr.: DE 205 198 055

emlix - smart embedded open source

--nextPart1922782.EugPuHskmN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iJwEAAECAAYFAlN+8QAACgkQq+RR+17trfxx1wP8DoKWvPE+OkJHU9GNtZGvMc5O
QB+oE0ze1TOja0pudZ0Dm1uQsu7tYwriyTf7mmeaVRs7dq4bhN9xKdbJgacKaLdd
DlvaCU5dtvwpPEiAMdRvce+vDdeymXIMmwN5duuxg/q/bUFkUTjS3RFzTjBj8du1
IiQakdk/fHAToXf8gMo=
=xs/A
-----END PGP SIGNATURE-----

--nextPart1922782.EugPuHskmN--

