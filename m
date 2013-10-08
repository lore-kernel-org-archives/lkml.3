Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab3JHJkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:40:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60183 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754902Ab3JHJkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:40:06 -0400
Date: Tue, 8 Oct 2013 11:36:21 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: oliver+list@schinagl.nl
Cc: rob.herring@calxeda.com, oliver@schinagl.nl, pawel.moll@arm.com,
        swarren@wwwdotorg.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, dev@linux-sunxi.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: sunxi: dts: Add support for the cubieboard3, the
 CubieTruck
Message-ID: <20131008093621.GC3041@lukather>
References: <1381220552-3123-1-git-send-email-oliver+list@schinagl.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2/5bycvrmDh4d1IB"
Content-Disposition: inline
In-Reply-To: <1381220552-3123-1-git-send-email-oliver+list@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2/5bycvrmDh4d1IB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 08, 2013 at 10:22:32AM +0200, oliver+list@schinagl.nl wrote:
> From: Oliver Schinagl <oliver@schinagl.nl>
>=20
> Cubietech introduced a new cubieboard, the CubieTruck. This board added
> more output connectors and features 2 GiB of RAM and a Gigabit PHY.
>=20
> Tested are are uart0 and LEDS which both work as expected.
>=20
> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>

Applied to my sunxi/dt-for-3.13 branch.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--2/5bycvrmDh4d1IB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSU9IVAAoJEBx+YmzsjxAgmKsP/j3e48TcD5ZIHOEdu7sPMDCX
hYBFlPDJC4yPTyz1Fn16QrN8Z6Do+L9H6NETiIyoQv7gPgE8TK3fk0Yt2RIwgVym
wuBSdR7CTHdkwKAk4kmrNUyrQZMEjZuWXs0oE/NzXp5ls0evMx5V/o2SjcSM8K6j
4yDsmV8YIyc7khaaOYAtKxu/Wv7Sfd+4yhzWe/jEhvwGhYyHdbAK7bvRQP80gqs9
k7uE3u+WTfA79ED7yfpSiAmhKQGYbJnq7VdUioWMMzTH59xEAqVEt7CberJFCHmg
iva3hkeiIf12xBTCGPYJoBDbmHGLrnGz6v/fOnmWq3qDbVA03xFxwB1/kh2vYtWm
r7IqViEG0KuzNmRXmEw5rAvrUx+s5972f4R8RCzXmokIjldnxkWeDCaV5E+9DusK
PIHPeE0pftLJbQf1b3T8LQbeLnYfuc+7qqHrLOT1aWW9BPMS/ZqnJobaiEBPDaOV
VgTL/p7JthSNwQLQOIYpdgARjKc310oSKN6y3ut3V+1nAvBkFLIrDcnAqD8CnwcZ
g2/lHA6qIyHmhI6nSDjglyncYmIExPSa8nagRa9iIit7+Obwkw3uSkL/67aUD5rp
cPof6oQJSMckY144zi801tyvvLQHsWgHFNv9SqeQKz/OIWpIylmUMRdXr4hq6Q1n
R0UdIkg7FEA5vGfh/p2h
=/FRJ
-----END PGP SIGNATURE-----

--2/5bycvrmDh4d1IB--
