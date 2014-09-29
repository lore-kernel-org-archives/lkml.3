Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaI2IXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:23:32 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:41653 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaI2IX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:23:28 -0400
Date: Mon, 29 Sep 2014 10:23:25 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "chris@zankel.net" <chris@zankel.net>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "deller@gmx.de" <deller@gmx.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "jesper.nilsson@axis.com" <jesper.nilsson@axis.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "starvik@axis.com" <starvik@axis.com>,
        "takata@linux-m32r.org" <takata@linux-m32r.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "daniel.thompson@linaro.org" <daniel.thompson@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>
Subject: Re: [PATCH v3 00/17] Cross-architecture definitions of relaxed MMIO
 accessors
Message-ID: <20140929082323.GE12506@ulmo>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
 <9197976.uQdLmtvIl1@wuerfel>
 <20140926134608.GT5182@n2100.arm.linux.org.uk>
 <3359318.XmOCYLZHTV@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cpvLTH7QU4gwfq3S"
Content-Disposition: inline
In-Reply-To: <3359318.XmOCYLZHTV@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cpvLTH7QU4gwfq3S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 26, 2014 at 11:36:13PM +0200, Arnd Bergmann wrote:
> On Friday 26 September 2014 14:46:08 Russell King - ARM Linux wrote:
> >=20
> > Obviously, this does nothing for the:
> >=20
> > include/asm-generic/io.h:804:29: error: redefinition of 'virt_to_bus'
> > include/asm-generic/io.h:809:21: error: redefinition of 'bus_to_virt'
> >=20
> > errors which are also reported in Olof's build system.
> >=20
> > Given how close we are to the merge window, I'd suggest this stuff gets
> > reverted so that it can have a better period of testing, rather than
> > stuffing it into -next at such a critical time.
>=20
> Right, I've fixed these all up locally, but then found new warnings on
> allmodconfig builds that I haven't been able to track down yet.
>=20
> I've dropped everything from the asm-generic tree now, so we can get
> a clean linux-next tree.

How about if I keep iterating this series? It seems like most failures
can be reproduced by doing ARM defconfig and allmodconfig builds, so
I'll do those and fix up any issues I find. Hopefully I can squash all
these before 3.18-rc1, then we can take it into linux-next early for
3.19? In the meantime perhaps I can work with Olof to get a branch with
these patches tested on his builder? And perhaps on the 0-day builder in
addition?

Thierry

--cpvLTH7QU4gwfq3S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUKRb7AAoJEN0jrNd/PrOhshQP/RiSEwIi1Y4jQR6s76b28fz0
JQ5L1MNGQE98LBHMJqd5nRkOhoTb91WrIVzhXtO4AsqyvuQZ75K7dP4u2v0PtRr4
Qz7w1XuHU6z79nv9R82jOhWplQymANW/3pfgpNbmRNW9t2OxVvsdyvDDk8eRZJ8T
NxYSW5AA76ZU2NbNaN+cd/UKm5BQB979v5Y1rv9UVGzdU7H9Y463VhWheIp4GuzF
cjgN7skIOeo7nE/YKKsmzzXIaxZG0rF8KaMpc+0eCfTFR4gr5hgAf9iCpJ5es9JP
z40zSojHMmBYGGBUFsG/fYcdVGkYk8ui5fB++9dGllI6Dk0juBOTOpNNQ3ewJWoj
mjWln79ljJZgVxqZ6RMB0yd6yAqzZHl+v29hiwzXS5RKFKJ7IqUA/JQ2in4fz8MI
q9z4/wrnH/YuClU26Ni7cuvXGSoN/hiDqBUeIujEM/rWQxT5XGjPWC7ez3+D5b/p
AOWVI/uajUIazESUVe4Rr7hDcMB7u39ZhXG75VyQz/6O3gkf3RtM0iKEAa6KSM6+
E8tvuV6Zoki1bj03XNM/d/QRvs+JLC+gqNptj1yU5d1RkH4TeNomtPr5tgkQ37zM
w8to/JRjqt+sT/K8N8472XOXxNdJyw9pSEgUtYVvHDRW+d7vNTeI0C3zzM5/RDF2
wCPg2Rovs0sGKhHCEAxU
=+Hzh
-----END PGP SIGNATURE-----

--cpvLTH7QU4gwfq3S--
