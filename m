Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbbAOTD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:03:57 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34820 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbbAOTDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:03:54 -0500
Date: Thu, 15 Jan 2015 19:02:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Grant Likely <grant.likely@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
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
Message-ID: <20150115190220.GF3043@sirena.org.uk>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com>
 <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NG5rUlMnWRrIcOiS"
Content-Disposition: inline
In-Reply-To: <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
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


--NG5rUlMnWRrIcOiS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 15, 2015 at 06:23:47PM +0000, Catalin Marinas wrote:
> On Thu, Jan 15, 2015 at 04:26:20PM +0000, Grant Likely wrote:

> > I'll get right to the point: Can we please have this series queued up
> > for v3.20?

> Before you even ask for this, please look at the patches and realise
> that there is a complete lack of Reviewed-by tags on the code (well,
> apart from trivial Kconfig changes). In addition, the series touches on
> other subsystems like clocksource, irqchip, acpi and I don't see any
> acks from the corresponding maintainers. So even if I wanted to merge
> the series, there is no way it can be done without additional
> reviews/acks. On the document (last patch), I'd like to see a statement

There's probably a bit of a process problem here - these patches are all
being posted as part of big and apparently controversial threads with
subject lines in the form "ARM / ACPI:" so people could be forgiven for
just not even reading the e-mails enough to notice changes to their
subsystems.  Is it worth posting those patches separately more directly
to the relevant maintainers?

--NG5rUlMnWRrIcOiS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUuA67AAoJECTWi3JdVIfQPRkH/1ijhO5P9oVbefqwA7XIM/1e
ZtsyeEY0FD4aZGA98Z6GqpdQlKP5fAb+m66zOtoHDuZvyVkvriAWgLYvNpOBb5Rm
unWsQ2NzBoF2C2H4GsOECM1492Xq0cEWK8l5QfQTed+scK8Tgj+yKc1qQONK1dbU
pHochHpEq/HJnBLiiXviGVO1pCrpGzGC74GFYqi4OLuhd2Ke9deMqM4BEXgH1SFj
JgIv2TuPrDGMNGG6FEww0VPERONsVkMg8clTdqdvTpMLz31z+Bl1Wd8jOO7z7PsE
te05HzOrz18rsop7JpbxJ2ac2gYAE1diIiEnyh9ypXpyXdbvw2L/StqjkPr1WrI=
=THbv
-----END PGP SIGNATURE-----

--NG5rUlMnWRrIcOiS--
