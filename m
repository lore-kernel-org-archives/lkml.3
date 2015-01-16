Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbbAPLuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:50:18 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38710 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbbAPLuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:50:16 -0500
Date: Fri, 16 Jan 2015 11:49:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Yijing Wang <wangyijing@huawei.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-acpi <linaro-acpi@lists.linaro.org>
Message-ID: <20150116114921.GJ3043@sirena.org.uk>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com>
 <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
 <20150115190220.GF3043@sirena.org.uk>
 <20150115200437.GF24989@titan.lakedaemon.net>
 <20150115203159.GG3043@sirena.org.uk>
 <20150115205139.GG24989@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6xTM0kUsJcaNctaW"
Content-Disposition: inline
In-Reply-To: <20150115205139.GG24989@titan.lakedaemon.net>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6xTM0kUsJcaNctaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 15, 2015 at 03:51:39PM -0500, Jason Cooper wrote:
> On Thu, Jan 15, 2015 at 08:31:59PM +0000, Mark Brown wrote:

> > Just changing the subject lines to be more suitable would help, but
> > given the painful thread it's probably worth going the extra step if
> > the lack of these reviews is a causing problems - I know that even with
> > a suitable subject line if I'm busy then I'm fairly likely to zone out
> > something in the middle a big series that doesn't seem to be going
> > anywhere.

> True, I was merely expressing a preference.  A lot of series containing
> irqchip changes tend to have build dependencies outside of
> drivers/irqchip. So I like to see the whole picture to decide how best
> to handle the patches.

Right, I didn't mean stop sending things as part of this series but
rather send them separately as well.

--6xTM0kUsJcaNctaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUuPrAAAoJECTWi3JdVIfQbzkH/3vYd/TXoe+6qBpNohChlVJ1
5d7Belq5eIYh4t+jPUmZpXGA3WgaZwpJL1+FpR4bHWGlkXckorWwZ2MaBh/FSYie
ZmYUgTdH8t9aBNe+9bLhfyqDt4oY1G/7TsIn+avk8EUtamsD2vXe5iqSOibtSmAV
iZ9YlgytxCmBbmRaRphxljISIZIYBSOiIgpQk5IN5wYoTDZyVYEOub8dxKbEY1qA
0bsNm/MoAo1U/lO1FE2+++8eX5g3K8d/gk+I+i8J1uRnwJpez/mzGnC7FPRIypkx
PKYHxf18jZE1tim2tOX3xu7tjAJUjr3/ieVcqmnrv+mT17X3dBlnZk/bz/PWWvs=
=Av7t
-----END PGP SIGNATURE-----

--6xTM0kUsJcaNctaW--
