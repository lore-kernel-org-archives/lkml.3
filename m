Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaCJXc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 19:32:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36965 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbaCJXc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 19:32:56 -0400
Date: Mon, 10 Mar 2014 23:32:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-arm-msm@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Message-ID: <20140310233236.GD28112@sirena.org.uk>
References: <1394477089-3996-1-git-send-email-joshc@codeaurora.org>
 <1394477089-3996-3-git-send-email-joshc@codeaurora.org>
 <20140310134741.e5b97d12d47e1b990501f8bc@linux-foundation.org>
 <20140310213524.GL18529@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kri9EcHK39A8PSyn"
Content-Disposition: inline
In-Reply-To: <20140310213524.GL18529@joshc.qualcomm.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/6] rtc: pm8xxx: use regmap API for register accesses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kri9EcHK39A8PSyn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 10, 2014 at 04:35:24PM -0500, Josh Cartwright wrote:
> On Mon, Mar 10, 2014 at 01:47:41PM -0700, Andrew Morton wrote:

> > Do we need a=20

> > 	depends on REGMAP

> > in Kconfig?

> Good question.  This driver already gets the REGMAP dependency through
> it's parent (MFD_PM8XXX), which does 'select REGMAP'.

> I recall there being some history as to why individual drivers shouldn't
> explicitly depend on REGMAP, as it's the parent drivers/subsystem
> responsibility to select it when needed, however I can't recall details.
> Perhaps it's due to REGMAP not being a user-selectable option.

Yeah, it should be a select of regmap because it's more of a helper
library than a user visible feature and it's usually only on the MFD
because you can't enable the function device without the core anyway.

--kri9EcHK39A8PSyn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHkuQAAoJELSic+t+oim9oTgP/jwxFm50fsZ0oqd8bElLPUSj
O57J2WcQjAnNo7Ks1wliK4feVWAgrNyidroE1E4NUeoQBFgbUvCD/+/y7ujkJnW4
mrwC8XHXJCYxleTvnEsz0xucV76EUcsw4/hKP80NsDUZ6Y3LUK53AaeoBr0nQLPS
yr/fGtdULsoArJmVp5eNpmlVngXGcHxVsJcNfnaPv9T6Woh9Ke7CfHGObTOm5Qdk
0Zkm3DCA3xPZ3PVY5D+xujJc55+EPXlgJ7LYDfK6C6aOPSyPk2hPJYLJyswCrjTx
Zc0t+LrYDFaj1wUOtPj2OacIf0WlaQOESLtYYta7Ej1xEFUbW8KnUiZdq80WCrJq
cDPt4fo/YnGmHyOojt0EAGb0VeCLQ+nUoYdg1tq+3Jk2DlBJq0TMy43s6d6XG/BM
0kg8kL74/Q1Eb3cMPgQOcfGdKNhPD7BL2xH7Mva4le59HZNay4JELjuny/nECFZY
azCCqpXp/BGL6wFw561Al9UNpq4Ak6K2ypTKOuojyRPGnzlWA7k6T8FivebpNeiD
+UAybgqr9VdhJHdKlZT+sMbyWVD9HZ59v7WhsiHTDEwFPr8G0xDY7/Tu7wmCQ5zL
VifaX+jmGjaxNNaFAeI3YSgQkhgCHooEsTNW4lPHQRn9GATiC0t+fYKvxiaRHmx2
+hDhta6M/UKeXEnZeO0X
=Xq/b
-----END PGP SIGNATURE-----

--kri9EcHK39A8PSyn--
