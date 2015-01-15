Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbbAOUcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 15:32:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35119 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbbAOUcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 15:32:52 -0500
Date: Thu, 15 Jan 2015 20:31:59 +0000
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
Message-ID: <20150115203159.GG3043@sirena.org.uk>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com>
 <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
 <20150115190220.GF3043@sirena.org.uk>
 <20150115200437.GF24989@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pVF9EYSGkiif4dMH"
Content-Disposition: inline
In-Reply-To: <20150115200437.GF24989@titan.lakedaemon.net>
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


--pVF9EYSGkiif4dMH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 15, 2015 at 03:04:37PM -0500, Jason Cooper wrote:
> On Thu, Jan 15, 2015 at 07:02:20PM +0000, Mark Brown wrote:

> > There's probably a bit of a process problem here - these patches are all
> > being posted as part of big and apparently controversial threads with
> > subject lines in the form "ARM / ACPI:" so people could be forgiven for
> > just not even reading the e-mails enough to notice changes to their
> > subsystems.  Is it worth posting those patches separately more directly
> > to the relevant maintainers?

> I think it's beneficial to post the entire series as one thread, but to
> change the subject line of each patch to adequately reflect the affected
> subsystem.

Just changing the subject lines to be more suitable would help, but
given the painful thread it's probably worth going the extra step if
the lack of these reviews is a causing problems - I know that even with
a suitable subject line if I'm busy then I'm fairly likely to zone out
something in the middle a big series that doesn't seem to be going
anywhere.

--pVF9EYSGkiif4dMH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUuCO/AAoJECTWi3JdVIfQgVUH/R+pj/lFK0/eUWUBKgec5yah
mP4d5UlCk2r/ikA4vaq3B7pwADDjNq+6fegY8xyQw7PK3lrifqpEEO4PiPtHLQtF
3DvrIXFZjZM0TNc3RlDQfZLDD9fFNQNG18h8+SV1d1r9zKvVaNA/EMGf20fVCFzs
G9Q/KI7qtzHKQ6A67WTIphyeiIiyEcmox436ktNBJRtiYhnMomUIY+s7I0D5aJ3n
ZFbdIPiAwn9db3GyRh3Mo9Kx0GOMoDXuFL408iwzc83bBOqrEiLdxdKvNBtnEDb5
wwkPRmBxOLbfzjZHJQrpeYnttmFaigAOLhmXAOo/QvHAFbECuWGcHZ6QDO1PFOI=
=xJ3q
-----END PGP SIGNATURE-----

--pVF9EYSGkiif4dMH--
