Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaEVHKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:10:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:43797 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaEVHKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:10:45 -0400
Date: Thu, 22 May 2014 09:10:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [patch 4/6] rtmutex: Confine deadlock logic to futex
Message-ID: <20140522071039.GO30445@twins.programming.kicks-ass.net>
References: <20140522031841.797415507@linutronix.de>
 <20140522031950.044848781@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mKGVDr+iJdqKOcjA"
Content-Disposition: inline
In-Reply-To: <20140522031950.044848781@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mKGVDr+iJdqKOcjA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2014 at 03:25:50AM -0000, Thomas Gleixner wrote:
> The builtin tester is gone,, so the deadlock logic is now only
> required for futexes.
>=20
> Remove the extra arguments for the public functions and also for the
> futex specific ones which get always called with deadlock detection
> enabled.

This reminds me, the raw rt_mutex primitives have no lockdep support,
and we've grown a few users in-tree. We should fix that.

--mKGVDr+iJdqKOcjA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfaLvAAoJEHZH4aRLwOS6Ym8P/Rkc0ckgQ5NbJWjGDdZ/ygzy
dPdeia/L5PX+JaG/cMrKw3ng1SutEbs8usLT6vMUvq91HRkZf3veYRIj5O+VY3tN
2GZeoQzLnl8FdlgW+oyt/H6LqdTUT5Va2sqk/EIT8YJHdlpRs/pjo2Nqb8p+NkiS
n3dlgOgsl5TkEsZDw9qX42sz0QFO8eYjaRSQu9Acq9FDYl9MdVipuoPc3mdbtIE/
kr5qtNzq7wWoF4YFlEewM2KL4ObUjjjyBZV8REaaG/aeHRSBDIANERggXzeXe99q
YMo/LQuP2DaYSJPJZmEaFwWF4zJVQJ4vKs8uNvwckCN4NvbB438P8ocmP6nTzUSN
yJOpnxPE9K1/+3ED1s8rF+78aJJvS0EsX+P5ZnxcHKBmZuydIhdCwDNK0XH3Rhqo
6w1NAI/1S9NEda2ZMSRdrTKtSEPWEeTShvWZxkRn1q4Cun8H9tY0CYjx++D4bVtQ
rZaLrYNxgCrhdvWZ0ofLM+8selUBeWJoOXkNB61iJG/+VJP5lZPCPZ0L0AD5Apw5
uNBQFj9JC4noF4AsUu0xjHh4Q8zK4ck3hbUj3G1laKoNNbSNh3rBvA4nyFyduYIt
kvHpmzEYg2s7jm/zSnH/YcvEiHAo3AjlQc/Rfbge9ecZRDiHxhFNPVBGh+LQiLal
I33vSfCarbWnvOvTqIjr
=exIs
-----END PGP SIGNATURE-----

--mKGVDr+iJdqKOcjA--
