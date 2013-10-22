Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab3JVIeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 04:34:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54836 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3JVIer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:34:47 -0400
Date: Tue, 22 Oct 2013 09:34:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20131022083401.GB20821@sirena.org.uk>
References: <1382362971-16763-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <1382362971-16763-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 77.221.165.98
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi/s3c64xx: Do not ignore return value of
 spi_master_resume/suspend
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 21, 2013 at 03:42:49PM +0200, Krzysztof Kozlowski wrote:
> During PM resume and suspend do not ignore the return value of
> spi_master_suspend() or spi_master_resume(). Instead pass it further.

Applied both, thanks.

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSZjh2AAoJELSic+t+oim9sRoP/Ay1CyZUecRw/nViX/66ZvNS
QJhvI+1zo9wLvokdZtQUzGubzDlntCN+PEblO7kqRlmEqXAou80t9qjOmhMADsMr
7QqGGrl5UK0eNs7VFpQMEkh/iYpRARwCtee5D2bP7uwobkeGJxnwovYllEw0Fw/7
AVcGzk22Pjp2lr+KxrVCe3/tfXxZC8L2+mq3xL3S6A1GQNBDkO2Vff/9KWQaZ3Va
O2TFu150L0A9SO+Q06wXN+ggF9ETNsRSfAvJcWz2JRIyKNlUsSC3bBtBq5t22k3X
Lse7As428HnF4xcxzM640k+aKJMwrwD8ewkZuzJwJ9dE3NbWDw6KyMcKjzMreQNb
bhkHFGiGw2OvFWnTNX7vED/CFR1MQxt3R/rjyokfax6HPD5HlTe/VwLaKJ3An/Xf
JSf97qxCuFlcyuO3XrawpUbwT9jruN0aB8Fs6PPX0RrrpijrrqySMj/U0LhnAFPZ
m3UOqB8Aix8FQ8nign1SH9nhKcIQlOuAKgJLVPO3ToxQepv+6Rk0ubX2KOOq28pt
9ikaLBK3T7uv5w3+QMcvIVxJmR59wOulKputvxq4iawQuyHLUPBFs1rPU3IKMUlx
iS4NtYljoEQs1RDFmMLHM7IBfGR7h1qHrqshNYSkcVltn3fRt7UlO86sLwZFwDpp
LiTK6c7CgKxwiO6+Vkzv
=D5GZ
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
