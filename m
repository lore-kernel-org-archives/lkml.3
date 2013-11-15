Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3KOWwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:52:54 -0500
Received: from sauhun.de ([89.238.76.85]:44829 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab3KOWwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:52:45 -0500
Date: Fri, 15 Nov 2013 23:52:34 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linaro Patches List <patches@linaro.org>
Subject: Re: [PATCH v2 0/5] Add-Broadcom-Kona-I2C-Support
Message-ID: <20131115225234.GC2672@katana>
References: <1384462936-7906-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gr/z0/N6AeWAPJVB"
Content-Disposition: inline
In-Reply-To: <1384462936-7906-1-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gr/z0/N6AeWAPJVB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 14, 2013 at 01:02:11PM -0800, Tim Kryger wrote:
> This series adds support for the Kona I2C bus found on Broadcom mobile
> SoCs like the bcm11351 (aka bcm281xx) and enables it on the bcm28155-ap
> board.
>=20
> It depends upon the following commit:
>   http://lkml.indiana.edu/hypermail/linux/kernel/1311.1/03583.html

Fixed Kconfig sorting, squashed broken out patches 1-3 into one and
applied to for-next, thanks! Let me know if I should take patches 4-5
also, but usually they go via arm-soc. Also, please provide a "Changes
since V1" log which will speed up reviewing.

Thanks,

   Wolfram


--gr/z0/N6AeWAPJVB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJShqWyAAoJEBQN5MwUoCm29OgQAIaT+x3Kn4hRankq0+PVqnjB
PAiCLkq1zJMq5ne6mZ8YQzg0cDnHmN3o9liVMV+kZKgiveizSpEhrWTlH1XzOUxE
EkRUnVQWWrjZnKzmY8pEIYWn0MMG+ThkjN9PydG7T3ZFoNjlQXeoBUl2Y1r6wRJx
xGYgB1ZmZRrBx+RIjrCiVQ8RmSCae7bFODCZC1ADMRi5N46mANSf1XazifbuUasd
Rm6u00JAFHoPDOPhPj5B6NTy0piJmC2zvZcqUHLq2rdCCjBI8TZsfwoI/CgVMo12
e+v/VZQlxFC4Jr9QNqb+cSpMmIcGj4ahCaHk2jOraXuuhBzF8lIzF3BILDWfQnay
htTGFqId38gLaXx8W/vxEh9o+p3BRzzU+sjVDazFRqCFi+jw9Q6yzwN45hoDnCiQ
EcWA8Jyf/ry/0zbt1OaepNet5uq6kyzNUkfLxw0ztn/1W/cwE6LQeotI3yZthdSQ
GE0Twov3LV11Jpo5PmUY8uvNLRw4voaqvUIah+4bbo+w/i/hwYlMfL6L4t0djjqU
3nTOEx6ODRv18CxGEA6KmgsdPqSmp5x/BGV7/yMFaX2qNTLpHF7ioQj3L342xBuC
FQL36DeBfqCPxJLfuz4MP1jPZlteoh6IMxuegHealNlXtYd3ei8zogqLAT+MGnzG
VetCw+10ADyinFSqDWBq
=3CHQ
-----END PGP SIGNATURE-----

--gr/z0/N6AeWAPJVB--
