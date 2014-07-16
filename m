Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562AbaGPMhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:37:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:34716 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096AbaGPMhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:37:38 -0400
Date: Wed, 16 Jul 2014 14:37:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        John Stultz <john.stultz@linaro.org>
Subject: Re: firewire: CLOCK_MONOTONIC_RAW exposure
Message-ID: <20140716123727.GA19379@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1407161151450.24854@nanos>
 <53C6633D.9080905@ladisch.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JLWO/V0yHeVFnBre"
Content-Disposition: inline
In-Reply-To: <53C6633D.9080905@ladisch.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JLWO/V0yHeVFnBre
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 16, 2014 at 01:34:21PM +0200, Clemens Ladisch wrote:
> Thomas Gleixner wrote:
> > I wonder why firewire exposed CLOCK_MONOTONIC_RAW to user space.
> >
> > What's the purpose of that? CLOCK_MONOTONIC_RAW is the raw time based
> > on the initial frequency setup of the clocksource. That can be quite
> > off from the NTP corrected frequency which is exposed by
> > CLOCK_MONOTONIC.
>=20
> The purpose is to get a stable clock, i.e., to avoid clock rate changes
> caused by NTP corrections.

That's maybe half an answer; what do you need that for?

--JLWO/V0yHeVFnBre
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxnICAAoJEHZH4aRLwOS6u7MP+wSnjQkCPOishkdLj99xaKu2
xayENVWW/yJp0ja1EJ/wuQHFdK9eS3nJ8o3p7jRtF/23MZLZ6Kwf8mZOyBTDQAXz
svTGRY+Dl2QiAT78Imaj4eu5DsEU8FWsIEFO6QdseU8LDl3uud4soFWB3AuEeW5e
3f/HiNSmjcozw1VV8+EUipVsUOb/nJ+3zoyF5qfcNFPEdLb/3jm2+ccdFCwhV8R1
W3UFzGWiOrUFClZ+kNXKzWttbCRI8YCnLH1d8+KtYzKvzZkVAsrOUjn5vIeg6kKv
t94NSMotDT60wcwC3XxlG3u5SmJR2byVHlGMrY4YXIA2p6vK8yFAQBbsDtC8N7Gv
f9hBPL/pw0AtmBZbYvEeVrF1M8iYWk+Kg4wkiPErveJfvcyhnPnJHJzyyR1U66FE
vs8FC3NobCd9hPV/i09jwf+LTO455kFuIBDPbmeyuw9RmeKCgWiZSJ705K4dE5P2
6KNUezPEY9ktdyCgRhA5ImgyxYo97xB1X5BEuAg5Q7ruRHPi2wi8X7Oi/eNYjFS5
ANcHW9VgKIJv7GMwMEY7+CDUO11rrukOnK7B04RGpRZ/O1enAx7CwygZ6aXCSWLU
yEiukYsIqsVj/YbYUTld2nDVrZ9UHd8VxenMCTKu1QQ1bfkkEv4nfr49WrsGSQ2t
G4XTMC4R9nIwNMMUUiDI
=6jqO
-----END PGP SIGNATURE-----

--JLWO/V0yHeVFnBre--
