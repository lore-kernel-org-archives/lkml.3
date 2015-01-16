Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbbAPMGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:06:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38806 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbbAPMGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:06:16 -0500
Date: Fri, 16 Jan 2015 12:05:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
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
Message-ID: <20150116120518.GK3043@sirena.org.uk>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com>
 <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
 <20150115190220.GF3043@sirena.org.uk>
 <20150115200437.GF24989@titan.lakedaemon.net>
 <20150116101034.GC13634@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="qE0/TkNoJLLGUzs4"
Content-Disposition: inline
In-Reply-To: <20150116101034.GC13634@e104818-lin.cambridge.arm.com>
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


--qE0/TkNoJLLGUzs4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 16, 2015 at 10:10:34AM +0000, Catalin Marinas wrote:

> Indeed, keeping the series as one thread is better. Apart from a
> slightly less misleading subject, I suggest Hanjun that he passes each
> patch via get_maintainer.pl and adds the corresponding Cc: lines to the
> commit log. I think that's a clearer way keep track of who needs to
> ack/review the patches.

I'm not saying stop sending them as part of this series, I'm saying it
might help to get people to look at them if they were also sent
disassociated from it - in the situations where I end up ignoring things
that look controversial but unexciting for my bit of it I know I won't
even bother opening the e-mails since I know it's just going to get
resent anyway quite often with revisions from whatever makes the rest of
the series controversial, I expect others will do the same.

Actually, another thing that might help would be if you and/or Will were
to prod the relevant people for review, letting them know that the
controversy isn't likely to affect their bits.

--qE0/TkNoJLLGUzs4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUuP59AAoJECTWi3JdVIfQgsUH/2Cg64q09u2ooIsIR3f7b0kP
zd6riu37dYZhqnYCBnPhAM4rPRVtAAxx4d5AL9xQPuGUzyFYHmP8MWyiTGgTmetP
Gg5sCzTi2UjSThOJpcNmWC1kPFCszuUUQ/A7OMq09dAWvIzJh8Ygd2DzE9/22J+s
9vhcDUnJ6yOwlPDs/kkMG017I3zSgMKnWk13KEitcXh/B8GUuAp7HrcmFh5CddrY
wavV6wO2Lk7d1TmB8DyiQDAc2BkSJgtXTuAWteGtaPN21NVp6nzInRi0wUWQtRr6
k54DPRatvc5E6TX+388/PvUPZEC/1m96+J5gL31YBr6clZTt4600+dlTk2ITWU8=
=RsnB
-----END PGP SIGNATURE-----

--qE0/TkNoJLLGUzs4--
