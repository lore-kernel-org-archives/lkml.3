Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3F1UDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:03:35 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:33797 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3F1UDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:03:34 -0400
Date: Fri, 28 Jun 2013 22:03:33 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>
Subject: Re: [PATCH 0/2] ARM: sunxi: Convert DTSI to new CPU bindings
Message-ID: <20130628200333.GA2756@lukather>
References: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com>
 <20130628171532.GD30603@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <20130628171532.GD30603@e102568-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2013 at 06:15:32PM +0100, Lorenzo Pieralisi wrote:
> On Fri, Jun 28, 2013 at 05:44:02PM +0100, Maxime Ripard wrote:
> > Hi Arnd, Olof,
> >=20
> > Sorry for steping in so late, but these two patches fixes a warning
> > introduced by the commit 1ba9bf0a (ARM: 7762/1: kernel: fix
> > arm_dt_init_cpu_maps() to skip non-cpu nodes) after 3.10-rc7.
> >=20
> > These two patches solve the situation for sunxi. The first one by
> > Lorenzo is to be applied for 3.10 if it's still possible, and the
> > second one on top of arm-soc/for-next. Tell me if you prefer a more
> > formal pull request for these patches
> >=20
> > Thanks!
> > Maxime
> >=20
> > Lorenzo Pieralisi (1):
> >   ARM: dts: sunxi: cpus/cpu nodes dts updates
>=20
> The patch above should already be queued in next/dt right ?

Indeed.

Then why the latest patch of your patchset got in 3.10, while the
patches actually fixing the DT it would have impacted were delayed to
3.11?

(And why was it merged so late in the development cycle?)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzewVAAoJEBx+YmzsjxAgWmMP+gIbmPZRR7vL/9CfNeNYsgnG
NYgsTWM23ATJDa/RDj/vrtODHVvrs2SwxWByHvzEJLQkV/MnKDNKbDTKe3lxNnP5
emSCpbmJ1Jpw4pDl0goA49zMT2684jrdMNv8m7KxBJ16JR1SWuOSvSd4/hY8r+fG
16gKKSG/nLOTLJsYX2/dcZUxpSMJFq1ES33zO37qN5DVK2ZbMm0ZTvCDOW5uezEr
iHWsAVbo0p/CCE37jyebY5RfVm7cbrdujpWh5xfPgRqNdWcK2TBAxzBE1sPt4n8s
aiyQVAcWUh+0rDIosg7lXmXcUWUSjQN+AbLkdAspBYHQmjh8gDjTyMVusHuKcWjv
yTwp0E449BknDdbyo/3pGefhhmyrdPEerKO9rVNujXYolfqXdd7hfoV0DmRkhntF
4UAppPgR1Pk6KvVvlooG3mrVYF5CDUzzt+rP8UUzBTw+csonRfk80XzO0XLP2gvb
rr1bcSNUte3qQD/5ZuUIuqws5N2qkM/IsOc65uSRIDMBn0JfuHg9PAGBnLiRqKzx
7EA6B4lA+W7dJBmU818puza1loIkvp4MFQEtqvg1I4HMy7rUo9N40E/a6EOF/EyG
jjkgPpeubWfu3QLKGiPEfNXFazTv9hSwgMC1ZdoJcE3hylFOMn/G7JuRBHr9Zfez
N2eI0un/YE6uX2UgD7+0
=CCQP
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
