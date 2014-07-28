Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaG1PEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:04:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaG1PEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:04:47 -0400
Date: Mon, 28 Jul 2014 17:04:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] Revert "perf tools: Fix jump label always changing
 during tracing"
Message-ID: <20140728150433.GQ19379@twins.programming.kicks-ass.net>
References: <1406559662-4376-1-git-send-email-jolsa@kernel.org>
 <1406559662-4376-3-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="McmgqJn15zuLm7T+"
Content-Disposition: inline
In-Reply-To: <1406559662-4376-3-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--McmgqJn15zuLm7T+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 05:01:02PM +0200, Jiri Olsa wrote:
> This reverts commit deaff8b659cf4d34181c087b8cdf74f1eb17b02b.
>=20
> This commit makes CLOEXEC feature undetected for normal users,
> because per-cpu events are priviledged.
>=20
> Reported-by: Peter Zijlstra <peterz@infradead.org>

Thanks Jiri!

--McmgqJn15zuLm7T+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJT1maBAAoJEHZH4aRLwOS68H8P+MVsQ6mialvonAgBZxGF6+qc
MSg9D6nkVEQ5BtdlsQEvGHXNuefWxQOVhsiLk5lYtiFFg4sZs8bfy3EADILuKoVh
pXR0Eim3AKX8Gv743e6ungJENZ7xq1mSbf7tDyAhVuBjhGrSDcSadvaQ4nsZLCW0
O1DU03rveh2yNKK5PSR0ytZbrzwWqXcoSTJ+r7GzF1o9dKyVB7YCMRDpkqe1jU78
dg1xYk6Ht2kEXeRr0SJR5ITqpeBQfOjOWEMNrUt9bMUHiQvGPkksg9dvUrxQatSK
bHddxvXyR4yv2Ch5b56mjVa2v+alA6VXmJkOl83pbcYeg0duaN5TUtrlo2l/v2kz
o4xRoX6KmSFbdY6bGmoexshadp4T7g9QAhYmzyd7pIF7+0gt8r4CYr/KKBOueygg
n2KMGQNmKIGuaeIUtJrU8low5ZFQOp22NB+ov3fLVzF0POLWH3sRxDhZZIsJb+CG
7MFNJnvQVBObrGmUum5fGjnPkLliQQvFqNaiL+EYFwFIOcqFURvTfdtubIBEIDkY
MO7WGq30si2ZUOsoivHZHOAyhfoLxqnaOxGMCtlhcdrqZeqpCEE1eWqhdSTpMub7
JW9yQqpzQYh6KcqHiNQWRGKH6j8TNl1Ziwz8a75nqCaUAOZjO9BKBPDgMMXZ1/mc
QRT6RUcqJC/BNt9d6So=
=bTyl
-----END PGP SIGNATURE-----

--McmgqJn15zuLm7T+--
