Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659Ab3K0B0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:26:30 -0500
Received: from ring0.de ([91.143.88.219]:46115 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758905Ab3K0B00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:26:26 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Wed, 27 Nov 2013 02:26:02 +0100
From: Sebastian Reichel <sre@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add HSI subsystem
Message-ID: <20131127012600.GA23214@earth.universe>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
	Carlos Chinea <cch.devel@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Tony Lindgren <tony@atomide.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1385403450-18018-1-git-send-email-sre@debian.org>
 <CACRpkdYSXDAwS1mxLtUL7qpHkfD1efo1QF0OMKS-YHKM-689Kw@mail.gmail.com>
 <20131127001241.GA20111@earth.universe>
 <20131127001909.GB22610@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <20131127001909.GB22610@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2013 at 04:19:09PM -0800, Greg Kroah-Hartman wrote:
> On Wed, Nov 27, 2013 at 01:12:42AM +0100, Sebastian Reichel wrote:
> > On Wed, Nov 27, 2013 at 12:30:48AM +0100, Linus Walleij wrote:
> > > > +M:     Sebastian Reichel <sre@debian.org>
> > > > +S:     Maintained
> > > > +F:     Documentation/hsi/
> > > > +F:     drivers/hsi/
> > > > +F:     include/linux/hsi/
> > > > +F:     include/uapi/linux/hsi/
> > >=20
> > > Don't add directories that do not exist (yet).
> >=20
> > Sorry, that was not my intention. The documentation path was
> > supposed to be "Documentation/ABI/testing/sysfs-bus-hsi". The
> > other directories should exist. I will send an updated patch.
> >=20
> > Am I right, that this should go through Greg?
>=20
> Why me?

As far as i know the change is supposed to go through the
subsystem's git tree by default, but drivers/hsi is currently
orphaned.

You were suggested by scripts/get_maintainer.pl, because you
did some commits in drivers/hsi. You also maintain drivers/core
and drivers/misc, so I thought you would be a good entry point.

Should I send this directly to Linus instead ("THE REST" is the
only matching rule in the MAINTAINERS file)?

-- Sebastian

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSlUooAAoJENju1/PIO/qav/kP/3a/bbaQq3ir0SlAhnVeOIYO
JYgNfOaf/JeBi/JXlbtLln8/QR0Lwxw4hXIoh8c58qGX39lYOL0t9x34vzTZde52
wLqUtp+OKQivdoiAVzMN0T2lmpG3QcX0ILVzphgKWG/TqXOrRu3kKoVEUNBtWaWb
b5KIX1u9YZ0FErocQrG3hIPfJC7OMjvfJIPx7UG/agdCWzh0D9qEQ2YTEPTG4zql
lHSSZvNgIfnRKB0qxBnTSbRrcDoh6FjcC00rkK+NIvCZIrqa24UOlziGESU68Pwz
56RyEX5tzK8KRsVBw+HKx5vNRxMOocUdph82MLGyud1AyQBOk1Pij1L+MxkSuBh3
8zo/EFT4hUTPjxoL5JUu2uxGDjPO9c5rcRGGq6c4ECE9lfXr8gl1BzRiXAcqcM/4
l4kVnehrdYz/XGnePxhuwGn+uiu6DgedD8Ay+TrPr7Isyir+vwbsHxaWQAFm9WEr
C7jn5HD1SMkXH39reiBV9YNlv82omVHcrNrd3aB5ECbsRbhAGqyaYL8KTsCu4cMU
GHDoYImdq/0zMo/G2MWCKb8TENX0qxJEm1wwS6uu071aR3sRVVc7D7Lck/l2nEFf
Gc0sZN0kTDDZBD0ifyB0Kc3pNstDEi2PpbqHB2BGsgW7f5AI2Q3/egLTVMqoGcf7
OAKdUfF6NeVJZqpjn5qt
=8I3i
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
