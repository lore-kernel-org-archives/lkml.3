Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaKJPRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:17:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56647 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaKJPRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:17:10 -0500
Date: Mon, 10 Nov 2014 15:15:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20141110151554.GC3815@sirena.org.uk>
References: <1415448772-3895-1-git-send-email-badarkhe.manish@gmail.com>
 <20141109091932.GJ2722@sirena.org.uk>
 <CAKDJKT5yKp-JyGEsOjcQ=bxd6OddQqZgx0E8s2k=i-jHj9nRHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7iqzzmjEMnnYslDD"
Content-Disposition: inline
In-Reply-To: <CAKDJKT5yKp-JyGEsOjcQ=bxd6OddQqZgx0E8s2k=i-jHj9nRHA@mail.gmail.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: tps65218: Remove '.owner' field
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7iqzzmjEMnnYslDD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 10, 2014 at 07:49:16PM +0530, Manish Badarkhe wrote:
> On Sun, Nov 9, 2014 at 2:49 PM, Mark Brown <broonie@kernel.org> wrote:

> > Same question as ever with this stuff: if we've decided to do this why
> > are we doing it for a single driver and not as a genric cleanup?

> There are many drivers needs to be changed with such fix.
> Can we fix drivers with this fix module by module or all at once?
> Please let me know your opinion.

All at once, though I think Greg just did that in -next anyway.

--7iqzzmjEMnnYslDD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUYNapAAoJECTWi3JdVIfQ5SMH/0Dl1q7kd8S3T8CfXXGEcDpu
OfJdUcl/mKzAgM2XNvWYcVUBotptTQ+FZVzFHmFpcXxeN054nsbPk++VUlx4tEm8
tq+cSeiEMzQ3v/C8b5iS0RAIKwISZBnGlIOtJfqL3RiMKPVC7apBsBcHh+k6Tc63
MBIgxNbZ2fkiNHnK8cPzH9HOH80dnNzMRfjlQf/TS8+Z3wt8IDZy0Ciw6rW5k8H6
p3erB5JxZa2jvFOULopQ5jaYZX7Ju2i8ps/PZl6VvZ9Qu7gYbo8xUBnHsPJnOxLn
A9AbR+d1UhpXWcHOyalZmXjzRqnWan+OA/GhOOXsrdl5Mduy+PCfp5xRFhbhIqw=
=Rwu+
-----END PGP SIGNATURE-----

--7iqzzmjEMnnYslDD--
