Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbaGOQRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:17:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59266 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbaGOQRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:17:46 -0400
Date: Tue, 15 Jul 2014 18:17:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 39/41] perf tools: Allow TSC conversion on any arch
Message-ID: <20140715161733.GO6758@twins.programming.kicks-ass.net>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
 <1405332185-4050-40-git-send-email-adrian.hunter@intel.com>
 <20140715152003.GB6312@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B/Xvj+5d6YUiV57r"
Content-Disposition: inline
In-Reply-To: <20140715152003.GB6312@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B/Xvj+5d6YUiV57r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 12:20:03PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jul 14, 2014 at 01:03:03PM +0300, Adrian Hunter escreveu:
> > It is possible to record a perf.data file on
> > one architecture and process it on another.
> > Consequently, TSC conversion functions need
> > to be moved out of the arch directory.
>=20
> Can you state where a TSC is stored in perf.data, and how in the !x86
> arch this will be detected so that those functions will be used?

So there's nothing intrinsically x86/tsc about the perf interface here,
although that's currently the only one implementing this thing.

Other archs could equally expose their 'cycle' counter etc..

--B/Xvj+5d6YUiV57r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxVQdAAoJEHZH4aRLwOS6G/EP/3IHRVPcadz9Af9pxgp+IiaE
IGa6Q8+gbccSXZgw/IUQt/NlBaxCyS69H/xzqd5LYxoInWBcGgiw1XW5YFQyT07U
ahx1g/h/jwn0mxBwz7fRh1Kj5ifIQjk3j2N/+ODYQTtiQP4fU3SNRInFi1RQe5Gf
yEM9QXqJP96i96VPn35k7L3gpPkeZyJWTmhKg3ehAaNOWIdYXdbNRln+3R5wW1se
EhSsG9EcFdU8cMKtIAxCg/2J4bF3oitgd3zAi+2l9KoXW9e7lXt3Fvlnth45vIUH
Q0oIBXo3kKAXY6MRKwVYIzNPJAcky5TGhY96orkFlKxAimtpIyWbxdNrcrAEklT/
qu8k5kQc63HmywGb4/Xu4i8eLkhszdEx/7RGq/z0Iawt0vG8C7OoMxaVKmZ0KDBj
W3tZWdyjONnST15WJPBotZoYe783xvXN7LP50TwjSzwK/0doE9mRnYAk8o7Wxe+u
9nfFfzkzNhG7SjccDPAslAN3vBuVbugMYA1Y0tZouSXRcv0Lo6/dhFhUv+rEggzr
oBnUyTqTOz4ne9qMt50lc+r8XKPbRtoxMUI/hNhQCc5aTRI5RIv+OVvVbmPk908r
GtYVzw+26ffb3z+jyMTaVwa/19x4oVuku1lNHLREeQajfH8rQaZvADiBLv1kX5nQ
r32eDbu2ucsJPl8e+0mZ
=j9WP
-----END PGP SIGNATURE-----

--B/Xvj+5d6YUiV57r--
