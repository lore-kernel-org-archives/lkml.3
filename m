Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaHOVcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 17:32:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41323 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaHOVce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 17:32:34 -0400
Date: Fri, 15 Aug 2014 23:32:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: George Spelvin <linux@horizon.com>
Cc: zhaoxiu.zeng@gmail.com, akpm@linux-foundation.org, dhowells@redhat.com,
        jwboyer@redhat.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        takahiro.akashi@linaro.org
Subject: Re: [PATCH 1/1] GCD: add binary GCD algorithm
Message-ID: <20140815213209.GM19379@twins.programming.kicks-ass.net>
References: <20140815135855.GG19379@twins.programming.kicks-ass.net>
 <20140815201601.2497.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="32ASEZPnRmW2nYUc"
Content-Disposition: inline
In-Reply-To: <20140815201601.2497.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--32ASEZPnRmW2nYUc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 15, 2014 at 04:16:01PM -0400, George Spelvin wrote:
> What I'd like is a better way to automatically configure "divide is
> slow" from an architecture.

So the usual thing and have arch/*/Kconfig select the fancy one if it
doesn't have a hardware divide instruction.

For instance:

arch/arm/Kconfig:

config ARM
	...
	select GCD_FANCY_ALGO if CPU_v6

--32ASEZPnRmW2nYUc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7nxUAAoJEHZH4aRLwOS6FSMP/1hNE0Gyck0w+0dRiXcIBu19
Np5msQfCwMRFVg+tOxje4rzZAUk7JuL5AYpFcqBhUAgLCK9fFyr3g6PfggdqAfI4
biDaVlO76cc0G4PRINqO29j0N27C1Ai3ciGzGSE5Kh4q582bxSY5FG+fwxFG4x1w
4izGuTVq7HvOut14A4vcwRn79RYYnnVleoUciyBbDFVzYBIaKsk+89BQYV6QaeMl
Idb2TlCykySyq42WGll/+b+I1jkkoiOikWnH7O4saq3AETzI/A2/JWj2Rs4eX/U+
onztJcd8g/dbM67woj9E51PjpyWEMYLGD9n8R1IT2lZLaR9enp1BYM3SlEJUDl7x
k9PISNOjMlfI42XSIozEBmMJjfCkt5JNA4fAmDF1/nf8exy3q4g801Qkmcr2x8M5
pFm0s26aZcx66lR/D24+JRfc7+kJRfflMVpBy6sJlsZVdwGf0xRZzGa0R0vLVAsI
2O6qtYWISB3b4UqvZ0QjC+vFXDjWgIZxevjm0fZFaX3a5f0PWXsd+qRPqlCLhrxl
W2Z7Wi+fKEjyJTCWFh0Yb3w37im7dpdrqTaedguoTEpa2pn+D0+1RB6qbMapHKdS
fzdZYKMM8SM/OKhgNCxUqBOXfQ6pM5o+4mJPsiXTVTJOvvQHWoVyPkQaSYCYVyvb
5pFhhxRY6wbwUDYCJwGw
=2qHW
-----END PGP SIGNATURE-----

--32ASEZPnRmW2nYUc--
