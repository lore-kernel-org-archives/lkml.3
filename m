Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaELIFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:05:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:33664 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaELIFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:05:11 -0400
Date: Mon, 12 May 2014 10:05:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: xiakaixu <xiakaixu@huawei.com>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        paulus@samba.org, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Namhyung Kim <namhyung@kernel.org>, Huxinwei <huxinwei@huawei.com>,
        peifeiyue@huawei.com, fweisbec@gmail.com
Subject: Re: Does perf support different length of user-space hw_breakpoint?
Message-ID: <20140512080503.GL30445@twins.programming.kicks-ass.net>
References: <53707DD6.2000108@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="veZQh2nSsG1B2+Ku"
Content-Disposition: inline
In-Reply-To: <53707DD6.2000108@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--veZQh2nSsG1B2+Ku
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2014 at 03:52:54PM +0800, xiakaixu wrote:
> Hi guys,
>=20
> Does perf support different length of user-space hw_breakpoint,
> such as  HW_BREAKPOINT_LEN_1/HW_BREAKPOINT_LEN_2/HW_BREAKPOINT_LEN_4/
> HW_BREAKPOINT_LEN_8?
>=20
> Seems perf only support HW_BREAKPOINT_LEN_4/sizeof(long)
> by default from the source code and simple test.
>=20
> May I have your opinions if I want to trace different bytes of
> hw_breakpoint addr?

Frederic?

--veZQh2nSsG1B2+Ku
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTcICvAAoJEHZH4aRLwOS6l/UP/iWS4hWXFwuXTM16XGrUrSCD
W3Hl8LNN350YPObGxi0i3EQ3BnKqHbByTjJfeNIHo1LmGrza3dSWRccPafMAjOwr
x7zCHX7RJndE4EZ2zALK0BTEMhiSIDHSY4PDazGNfLpEGKFRo71A1v1n64xG9CFn
jVvvZI+naDy1zrp2zvLwW1uB8+7acCZFVHsgv0+rKq+B+XoJ3EuR43p1PhzclUDN
LVR+Bc6J/owZn0NHCYhFbEqiaPfBYHAbCnE/dgovU3kFQvlaqVYH8oCVAwG0XPRI
JOo407QNUah0qHKn0WR0oPybs9iWjWUyGwfhizE3TkHqnBVd+6JaKvI7MEu22yGg
sck4EkMKTfpv/fDS4BQzj+J2/8DaXfSjZOmRBPdT8k9iZ/hJWaIW1Qkxkx3Sg8zt
wQKGpcdRx/aaSZacisKT2iAANAcpGFktvMlr0BOz2dcDVEVx6lZDa5ak6kcxZ3ib
v4yPQvJzCqZodpEPBKHQzOt2bNanAeNWvzCMm2AqWGN66/pyrKIKQobxt0Ngw77a
EEUznvGMPBhpxUKymvFOcQCuKiY8yWEPszVbeuj1iRhbslBO8wIGiNMqRZQPdo8n
RDuBvU76FS0rBzHVMCOS0AePCN3eCBKibtuzCJIlN1OzHwhXLNvtwSweXLFR3IAp
wts8+RdvVbL9oynDV8YJ
=Z5sS
-----END PGP SIGNATURE-----

--veZQh2nSsG1B2+Ku--
