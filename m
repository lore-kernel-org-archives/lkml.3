Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbaAVQKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 11:10:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58134 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaAVQKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 11:10:45 -0500
Date: Wed, 22 Jan 2014 16:09:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com, alan@linux.intel.com,
        acme@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Message-ID: <20140122160917.GI17314@sirena.org.uk>
References: <tip-62f45f9a202c318fd5fb43cd40ef687b7dd2825f@git.kernel.org>
 <1390325069.2472.78.camel@joe-AO722>
 <20140122122728.GA8882@gmail.com>
 <1390395744.31946.45.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zEynTRz47X4emBJ"
Content-Disposition: inline
In-Reply-To: <1390395744.31946.45.camel@joe-AO722>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [tip:core/urgent] MAINTAINERS: Restore "L:
 linux-kernel@vger.kernel.org" entries
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9zEynTRz47X4emBJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 22, 2014 at 05:02:24AM -0800, Joe Perches wrote:
> On Wed, 2014-01-22 at 13:27 +0100, Ingo Molnar wrote:
> > * Joe Perches <joe@perches.com> wrote:

> > You have cut out my main argument from you reply and have ignored it:

> Not ignored.  Threaded email works fine.

> Your main argument is that some people don't cc lkml
> because section entries don't specify it explicitly.

> My main argument, which you elided, is that some people
> will not cc lkml because they will see some sections
> with L: entries with lkml and others without, and will
> therefore _not_ cc lkml instead.

> So I think the rule should be either every section has
> an lkml entry or no section does.

> Pick one.

> Mixing styles just causes a different type of error.

The other option is that we just don't worry if people CC lkml or not -
for things with a dedicated list it's not super critical that people CC
to lkml and in practice doing so would make it even harder to work with
than it is at the minute.  If they want to do so that's fine and it
shouldn't be a problem but at this point it's questionable if this is
something that we actively want to encourge.

In practice this is exactly what's been happening for years anyway so
it's not something I'd expect to be controversial.

--9zEynTRz47X4emBJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3+0qAAoJELSic+t+oim9eCEP/jEXbkvQXReoei9HVU5N5xEw
acMAGIO851u0fZswbR+R22NlxsUgdZvkn/6SeCTk+wo+Fzmup1xImtL4yHa4Vc3G
a9twnB0bKEWbUOi2BfFVc+qDEz/6dbuvBIR0xzCwDB300R1G5l1Hwm9RUVH8CfzM
N9PsjohYNhjgAHdqjDHy9Tbh96CMAudVmNAgcK4qFj3OuQvNMjfMUFDzpuUF1ijW
uf1PnjVnWb1Pv1+h63F9ha9t5tYlSnXYG9GKIgMw5wLpsDYK82Hop6EDe2jORxla
WKjX/+DGbBw/Fw5Js6ngWGxncjLdg/b+DUQJWoKTEMxR3SD6Oj9UVrg6PRmOpIDo
HbOpMuRTpCyuBEqKg/BR2/LdtwVeNP+gEYunLltOp9+gm1XDsKyWGEjNhLxnp0Lr
qUjKG74iAUCyfE3vvzWJXtBB0R7khAlBFxHHzWL0MAp2giF8ZmpfJh+4of1gil1S
MhdcIuwC2dmLgNZ0ymrQK/ZGGy5xlH7OgewhBMfkDghAO+UNUmUtMdYJx4r6ujOk
9sJUfC9g0N1EXrF6mJ9JZ1lAIbli9W09NDzTc2ExsTr7HLKmGEpJN3mMXpgRXgg1
TEl9ZV79NS3GMqqRtH+1a/pZ5RB/3aJNoa9WkRRCISjYk7ytn+Rl2e4Z2MT88BjT
OkmLFcEgcckFSiWEZQYz
=Jpxh
-----END PGP SIGNATURE-----

--9zEynTRz47X4emBJ--
