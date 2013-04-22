Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3DVPVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 11:21:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12695 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3DVPV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 11:21:29 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=bCoRy7igLC4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=CubMpH3XfAEA:10 a=cRYzl8i-cPchkIUPSN0A:9 a=QEXdDO2ut3YA:10 a=3N5AG7PEu9Askwon5WcA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130422152026.207981701@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 22 Apr 2013 11:20:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 0/2] tracing: Minor updates
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


This will be added to the queue for 3.10 and uploaded to my for-next
branch in my git repo.

Sahara (1):
      tracepoints: Prevent null probe from being added

Steven Rostedt (Red Hat) (1):
      tracing: Compare to 1 instead of zero for is_signed_type()

----
 include/linux/ftrace_event.h |    2 +-
 kernel/tracepoint.c          |   21 +++++++++++++--------
 2 files changed, 14 insertions(+), 9 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRdVV0AAoJEOdOSU1xswtMQ4AIAKKoQNRj/OCWB/KekQILwACg
defDU5oILac4fBPrmjd8Y2x0lRCl+tcij8SjTKHevupcm4CQR9vDJp9CliJuSxj1
V3zI1K77SaJDDynhUHgtMUlLeWCrcugLt3Am7+TWlj/+FHRSZrs6tWWQwp31g6Ow
nEZ4Om1Qrh9KQ29ecPmhkFzOyo8qNSprVnarXyYoZi70BGU+R1XGqQNly/jhpqqP
eUJJBzhjpk4LGLQ95+0WIdfTjlC0bDZwZXklnGkotUoV+wShBKWB+SQOsini4xcH
uDU9Cv3pGuqNbgSr+niIRPr0c9Ap9XETRFvVW7uaiqTkB6AK3VlGuIfehrPKe8c=
=0jmH
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
