Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaFZTZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:25:30 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56645 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbaFZTZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:25:29 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: Re: [RFA][PATCH 24/27] Blackfin: ftrace: Remove check of obsolete variable function_trace_stop
Date: Thu, 26 Jun 2014 15:25:31 -0400
Message-ID: <3144266.ziutPk5CNZ@vapier>
Organization: wh0rd.org
User-Agent: KMail/4.13.1 (Linux/3.14.2; KDE/4.13.1; x86_64; ; )
In-Reply-To: <20140626165853.211937817@goodmis.org>
References: <20140626165221.736847419@goodmis.org> <20140626165853.211937817@goodmis.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1508370.1FC40tlUPP"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1508370.1FC40tlUPP
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Thu 26 Jun 2014 12:52:45 Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>=20
> Nothing sets function_trace_stop to disable function tracing anymore.=

> Remove the check for it in the arch code.
>=20
> [ Please test this on your arch ]

i haven't tested, but the asm looks correct -- it's only using scratch=20=

registers, and the rest of the code doesn't rely on the state in that i=
fdef=20
(by design).

Acked-by: Mike Frysinger <vapier@gentoo.org>
=2Dmike
--nextPart1508370.1FC40tlUPP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJTrHOrAAoJEEFjO5/oN/WBIBAP/jG3a6aq1VWXYF3pCCZkAGRD
WqP8NHNFrabZaykxsgwgGzOqOIJYjIGHLB1SK7xRhKnqkG5oRB5F4sdULb2xAlyj
RxoHdB9fxJjV+wsGbfWNkn5khktANdslAXsgvkIIfCwff9HI9PeZ7L3OBjZWolJ4
GOzcgiH8pvmLClwSkkvUGgciBOtui9bCbMTiyBjYVgWRXxvAubfjCk5qES0TD5L9
AE2dJX2iB3U9L+ppuwfl4ExHpl53D2MO5ht0LuKPoJtgztjU+v/NtYDnwNZuPqls
44dtDa9xiidsLVmArr57pEnRjQdla/vPOil+FspV1HjdhFrrwJkcyLX4KcxB3mIB
x5Mi887+pDRrz1ICftUKNr8SXFfINkAQpNHNHRaFAWQoaiUVyInAOWqRmQqGNMCd
MWXW3Dt0QScSg4Bg/q1OwdlvRa1/ND5G/kbveWlX2JjkRRUpMrn35nX6qzq+WPlb
EIetjFEOXdqR2+rtf+xXFRkyMlT2a50n6c4g4WsX7gRg5RhhPbhZdPAn6zZ9gvtb
nPc15T6/RxFQ/F8px6tHbvqTZY7PBwUluVGaNqOvCvNT82Glvb7cdhrqbeV4AD81
T63eA4YeEPmQ6h9lcpzUL3px436ocIDtAAQpG5UF/nmwbcarXsNQMdzfQFy0rRcb
bSoi45PnMZwxw8sNyM/u
=S/EQ
-----END PGP SIGNATURE-----

--nextPart1508370.1FC40tlUPP--

