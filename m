Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab3EUAnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 20:43:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34571 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755993Ab3EUAnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 20:43:14 -0400
Message-ID: <1369096976.3469.131.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 0/5] perf: net_dropmonitor: Make it work and make it fast
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 21 May 2013 01:42:56 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-sE2Ny100rfYTLUcbwEec"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sE2Ny100rfYTLUcbwEec
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Somewhat surprisingly, the net_dropmonitor reporting script doesn't work
at all.  This series fixes it and then makes it slightly more efficient.

Ben.

Ben Hutchings (5):
  perf: net_dropmonitor: Fix trace parameter order
  perf: net_dropmonitor: Fix symbol-relative addresses
  perf: net_dropmonitor: Do not assume ordering of dictionaries
  perf: net_dropmonitor: Use bisection in symbol lookup
  perf: net_dropmonitor: Remove progress indicator

 tools/perf/scripts/python/net_dropmonitor.py |   39 ++++++++++++++--------=
----
 1 file changed, 21 insertions(+), 18 deletions(-)



--=-sE2Ny100rfYTLUcbwEec
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUZrDEOe/yOyVhhEJAQpagQ//TiqbLqaR0jmYqHJLQ58yKW5DJTa7gTuQ
QgGNlK+xkHC4yITHQYAbqrKOiuubAKiUkGm+NLku7LrwFh9fwtXGx/UAS0ThfQ+p
5ni5cssKiG/M7+Uxd1/rWZm9NO4zf0b0tXKw85/7LthhCck4bkgrFECJGYQKJax/
bZSBIKbS7wxw5ehrhP9WwRN1noBVMOo4SUiJyukQnbwTLOBYv1StIvsrdX4MWcZj
NlpT7wluIiBrGmuBCXFfuef+JvNg49Ry02O5ZtSwMUKcDJ0hxE0MhX7sbj7x94D5
Eq0TfL6F8acPy2KSyXUMOc75aPu1ytQuicBhAOWHGk+X8NBsm5v788NCwulYrL9X
sEY490hnX/cveuMCKjpOT0z5Z3AGT8ZIwOwsFTNltZPds5o+2yeqc7SA3VghPNJk
93FxaWLn+RYRVhED0kvuVAl+QF2MaCBEmSfWrDVgdeet+LNJm6AHaNMylicwJIpH
54qXxXlTYAfx+b5/91n/xdtf29VFp8nBLoPIFxI4rrRGRN2VQLpBMrGa+zeadG4p
ZZSfI4e3QrPRonirQFygqiJ+H+hzqi9mrfgPfzcHaIoifRHQixz+5Rk88+W2vtoN
rmtek4QDWcF3PMhwZLz1omtFX+wdYchJt7RYTPCGfGTC8sdwMea6SlpL8KVjUIvA
jTRFlGdtsj0=
=j5ZM
-----END PGP SIGNATURE-----

--=-sE2Ny100rfYTLUcbwEec--
