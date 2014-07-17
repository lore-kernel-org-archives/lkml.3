Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbaGQM1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:27:01 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:34618 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbaGQM05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:26:57 -0400
Date: Thu, 17 Jul 2014 14:26:51 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <Will.Deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] arm64: Use include/asm-generic/io.h
Message-ID: <20140717122649.GA1006@ulmo>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com>
 <1405508484-18303-3-git-send-email-thierry.reding@gmail.com>
 <20140717120441.GI18203@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20140717120441.GI18203@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 01:04:41PM +0100, Catalin Marinas wrote:
> On Wed, Jul 16, 2014 at 12:01:24PM +0100, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > Include the generic I/O header file so that duplicate implementations
> > can be removed. This will also help to establish consistency across more
> > architectures regarding which accessors they support.
> >=20
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> > Changes in v3:
> > - add io{read,write}{16,32}be() to match what 32-bit ARM does
>=20
> It looks fine. Thanks.

Great. Russell hasn't commented on this yet, anyone know how to get his
attention?

Thierry

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTx8EJAAoJEN0jrNd/PrOhr40QAJLXpX+mhdiIg8GsAbSqeFkj
4F7nDmE8JW+ejkD6WU7mhsbmxw9OgdURjzFzfYKF5KvgJXpP9hHSmmUBsUgF9ZFK
XbrCO1+JMqk9IzitSIx66eeGWBTRS0f4Dk8AJmNp/6begMCFeWX9RqeakJWATHNY
eMvRckbSBYEcYQB2/DYfxXFGq9WcEP94yPNcUAbf2wbqnsN5/Qju4OSGevuS/fJI
lioSAc9bEMjy2/mwAcwoYP3OpKIxJk4OTTMMMWWGA7sfWfkqKNfsSTmJW3TZ1gnn
GUJL1ak297tjikO4AWem4ya4DPmBV2kkw+iZzApd4QgJCDprpDgXycZbgS0r5v8M
YAHvv1BZpOqLOy05/+B5jFaOJpXjtgAh0FIjxqnNgPURF8Niiq5i6pEsYgEMtcUC
21N4Znn0nvUY3RdQ8IGUJynBrPn0kE0amzyF+/bfgK7XM9gKoFI36ZwtX8/JO1NS
jmkCabj26BoleeZWp2Qa07vYaE1n/kSCamsKa5J0Rd5B/duki0wzqK7fBG5TQf91
MpM52fRCq0iZ9tyj3b2nTRdbONACahvGvd+Ub+MjpLu8uQwRKYCPmx6qej90KwO9
E78IRo3Czin1gLmHkPsrEQ96+o3eKfqYOI/FfiBMqbSfDeTWj1j1I8QynHyywiZ3
K8ncs8XBEmEZL2TjVFnd
=7tkg
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
