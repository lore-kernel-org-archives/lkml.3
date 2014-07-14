Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaGNJsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:48:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39800 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaGNJsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:48:04 -0400
Date: Mon, 14 Jul 2014 11:47:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [patch 54/55] timekeeping: Provide fast and NMI safe access to
 CLOCK_MONOTONIC[_RAW]
Message-ID: <20140714094750.GO9918@twins.programming.kicks-ass.net>
References: <20140711133623.530368377@linutronix.de>
 <20140711133709.835700036@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+wSiqF7c0ySQ2tNi"
Content-Disposition: inline
In-Reply-To: <20140711133709.835700036@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+wSiqF7c0ySQ2tNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 11, 2014 at 01:45:19PM -0000, Thomas Gleixner wrote:
> +static struct tk_fast tk_fast_raw  ____cacheline_aligned;
> +static struct tk_fast tk_fast_mono ____cacheline_aligned;

Question to the 'trace maniacs'; why do you lot need access to mono_raw?

I would much prefer to limit choice here.

--+wSiqF7c0ySQ2tNi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw6dFAAoJEHZH4aRLwOS6brAP/2/fhXlb/7DB4gapVTDx2m7X
S6Vw6KQJASglEkJTRKEij9se+5y2i19qq2RNh0Q6RoFsHK4do1sne48BNp0cO8Kd
4z4c5jNQCpCzbrMgFtH3Lv6RvHm464GzbZXWTFRcUcPC3rGB+ULwsLGNBkO5PBA0
YF/+JzCYvYL5isDtniibfq8Pi0Y7u3Nrbdk8uU5oYBvyn09vzcsCXHTybK/rC+Lb
5/xyG1+VPeVg2rwUgt7xkFJdwB51I/pYVbvgfRv9REjO3/6PPlzyqFkVuKS/oe+b
M+72ogTjcyZt0R/59uliAFfovoiCdtTKtIqO4Oe+p2X+yPk8U3/7OyyyzaPCht1q
hOVPkmB2Xy5FhvyOPDB5YPYTl0FrDP7GpXDhCx8XMZM/IHBEO5UjR1dmIlMSBZAn
yKQgDEPPmPYbbBLuOOkv9fnryop4pcY9d52I1tvQUbCe0HXT/h5yCd9saahyxDUV
Z5m+GYY1OUjZUoFhRB0qz0ZpQ1/uasH8/R0pCLkavHsaXOp1V32ybASoHomsIeM2
KrfGriPg/TzzE3IA2n5362VYYYgd4ZT8mvhha5C5CaBfbGT8sFqhBOAQlsqJa1Hn
yto+JHNQay1XWHg7fWHDDe8nLqzawTMHBg6oWNKl0RtM5IQynL5n8PhZo8EsPNSK
gypr+Ic6HDInNUO3JW74
=aA0D
-----END PGP SIGNATURE-----

--+wSiqF7c0ySQ2tNi--
