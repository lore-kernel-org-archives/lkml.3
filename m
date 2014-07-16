Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609AbaGPDEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:04:47 -0400
Received: from ozlabs.org ([103.22.144.67]:39398 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981AbaGPDEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:04:44 -0400
Date: Wed, 16 Jul 2014 13:04:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20140716130434.6b09b2e1@canb.auug.org.au>
In-Reply-To: <20140715190807.GA26057@roeck-us.net>
References: <20140715132946.771def89@canb.auug.org.au>
	<53C4BF8E.4010509@roeck-us.net>
	<20140715155547.25959587@canb.auug.org.au>
	<20140715150801.7f8099b1@recife.lan>
	<20140715190807.GA26057@roeck-us.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/_WqxXsCgUMqdzJKyY.7q_tm"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_WqxXsCgUMqdzJKyY.7q_tm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Tue, 15 Jul 2014 12:08:07 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>
> > > > Do you mean b6220ad66 (sched: Fix compiler warnings) ? I thought th=
at was accepted
> > > > a week or so ago.
> > >=20
> > > That is in the tip tree and includes the fixups to powerpc and arm.  I
> > > don't merge the tip tree till well after the v4l-dvb tree.  The merge
> > > in the v4l-dvb tree included only the change to include/linus/sched.h
> > > and neither parent fo that merge was based on the tip tree ...
> > >=20
> > Stephen,=20
> >=20
> > Do you know if/when this patch will be merged upstream? It doesn't
> > seem to be at 2.6.16-rc5. Otherwise, I'll likely cherry-pick it on
> 	s/2.16/3.16/
> > my trees, as the lack of this fixup is making hard for me to check
> > if a media tree patch isn't introducing new warnings.
>=20
> Only queued for 3.17 as far as I can see, and not scheduled for 3.16.

Its in the sched/urgent branch of the tip tree, so hopefully it will go
to Linus shortly.

[ccing various tip tree maintainers ...]

Hi guys, this commit (b6220ad66 (sched: Fix compiler warnings)) fixes
lots of W=3D1 build warnings ... just wondering when it will progress?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/_WqxXsCgUMqdzJKyY.7q_tm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxevHAAoJEMDTa8Ir7ZwVVl8P/0Hg5EL5Z+RdhZSPJtYhzvLu
XeGrvjsRRFGfDMXpPaejARfSREF5OVuFVEhjoF5JX+tVvxlBTX7M/OBjSQlLY3kl
2ta+goJR1mA97jqHwcAoCgJY+cBhy1JJwIM9NfdctnOCgeYgig8N3YtALykTSp86
8RRt7aQdkhZbM69hSFMIQB7rFil9xO27QAQq/W9yDeGpm2GsVcazeGuXZAyQKW2o
U9KPpv/oNQMCvHOQpAvu6C5hgtRknJX4v6vgPt0t31wBt9PmzE9UuC4KDiPaYgRP
HWluuRFP+Qv46rFGjfUawAV6EWUhEsj7AuOonYqbHXt8SP0s4d4lyj77c9aBtv32
Vz8kD9vo92dAOuYK7s1098ApKDh9N6xF6qKcUTXTEq+r0uLo1RHcAUyOrxlLFQbw
YqezNfza1jAbc2Q2vVVUYg2GnVBEVpe+NFUpB7RQx7zPs50EqF5ccv+u7YQ4pzYX
NumE1ezld0R7pH9jsZQ5z3TQBEXCMUmbzK3hI+T7yVvR1rO550WDVrwd0PwFDqh1
DjfDJmPGr0nLI0sAFkkpmZNfTupevEAGKlGOIuW9wFvTsvk4MTkTw9ERNSJtE4Hu
pMAqfpuSF7S9CBQAU3mZypIu0M+BtO7vMZsgRzwV2JgF7kNh1irRkjoyb2GSSMie
x63We/leUf/2PeH10NHG
=uIdI
-----END PGP SIGNATURE-----

--Sig_/_WqxXsCgUMqdzJKyY.7q_tm--
