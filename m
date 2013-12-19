Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab3LSWj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:39:26 -0500
Received: from ozlabs.org ([203.10.76.45]:49362 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab3LSWjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:39:25 -0500
Date: Fri, 20 Dec 2013 09:39:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        <linux-next@vger.kernel.org>
Subject: Re: Could you include clockevents/clocksource tree in linux-next ?
Message-Id: <20131220093916.06b43263127f5d6428a9056f@canb.auug.org.au>
In-Reply-To: <52B363F1.2080209@linaro.org>
References: <52B363F1.2080209@linaro.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Dec_2013_09_39_16_+1100_UOk.bJtW/5oMf/F6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Dec_2013_09_39_16_+1100_UOk.bJtW/5oMf/F6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Thu, 19 Dec 2013 22:24:01 +0100 Daniel Lezcano <daniel.lezcano@linaro.or=
g> wrote:
>
> is it possible to add the clockevents/clocksource tree in linux-next.
>=20
> git://git.linaro.org/people/daniel.lezcano/linux.git clockevents/next
>=20
> It will be based on top of tip/timers/core.

Added from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Fri__20_Dec_2013_09_39_16_+1100_UOk.bJtW/5oMf/F6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSs3WYAAoJEMDTa8Ir7ZwVDwIP/iPO/HUZiTbDMvPq8pxEBe3h
l+4cfEHF3HJN/Y8AHauPwiRkngZghPslEeJSwyMC8rSaWrQPWYdn/qQNyuuzh7MZ
QLgBZkyBD5/fCIWTsAByeS77VV4a/SQAuHCJFDD806AmCjrYA8DBiotp01G4iAwr
JyvX+TgTWJpGbIH+ETqgwvW4M/7SeHUcodwbVxAQzpnW3YFKOy1RA22Ymke7xYnL
g2oNJoE4thZuNKLRxq1+W5ot6HBOsyXiAOUBv9PFxUDhXnm5lweEmg/t2i1sjQNh
ZNhuRXP2/S+4Tn5k1ueQDLmBYdQnZbK+4E4Bos71lJb/V2cFk6l0WA3l+g2m0D3x
Dmsw25ejBterYxl+ROhj2X5t20A8RGFJsM6/rEbs5oWBjddfkYePx9IG5mS1HY22
+NSrztr8tAzc2UB4hsbfP9Ir6EJrlfltbMJoNquXYGElKTcTa6lDFNOrOm55VgDX
aiZuk6bwoJLkGqwtzlKMprsiGOH7xlaTs1EJMGCvPfKP2wceQJldG1ZuWtEkOpFE
Kdv7f5PpEFMhDKlaJUJjJRmNAcaX8OE2qTpThLIOLbbRsVicD/1EGyJbjFvSJGgM
g6BQn8YCu7RkklSmZdciAKaXujP2VE7p53wuRxh/NGTZ8ZImSKTEBId1kvIXPLVJ
6wn+TCR6EUUdJ65PwF5B
=PGlI
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Dec_2013_09_39_16_+1100_UOk.bJtW/5oMf/F6--
