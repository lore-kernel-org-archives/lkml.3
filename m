Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3KYXlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:41:06 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46430 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab3KYXlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:41:03 -0500
Date: Tue, 26 Nov 2013 10:40:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        matthew.garrett@nebula.com
Subject: Re: Request to add chromeos platform tree to -next
Message-Id: <20131126104055.1b682623f32543d5027ecaff@canb.auug.org.au>
In-Reply-To: <20131125194116.GA22485@quad.lixom.net>
References: <20131125194116.GA22485@quad.lixom.net>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Nov_2013_10_40_55_+1100_h6tB05xROksXPu7t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Nov_2013_10_40_55_+1100_h6tB05xROksXPu7t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Olof,

On Mon, 25 Nov 2013 11:41:16 -0800 Olof Johansson <olof@lixom.net> wrote:
>
> I'm starting a git repo for the chromeos platform glue (x86 and ARM down
> the road, so far just x86 contents). Can you please add to linux-next?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/olof/chrome-platform.git
>=20
> Branch is for-next.

Added from today with just you as the contact.

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

--Signature=_Tue__26_Nov_2013_10_40_55_+1100_h6tB05xROksXPu7t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSk+ALAAoJEMDTa8Ir7ZwVzFMP/Rd/d3LaEgcRE/zQeEej0HZz
FNDBlXBvxpWyQNrofKkSxvK800J97INvNW5c75OX4dem5elp7U2ZpR5cl3CiB3jl
azXihiw7VBcwnl4CIwc2gpM4IuRUcNIhNDB/IKMdmcyYrGOayESCmhy9h5Sre4Ux
qJ53+n3TDu936WZtYdrL347CQlyi2Ic1icwM4yJ2sMUB+fZPo0pm9occR3HLEIPy
wmy5lLoI+KpztNxU4n2+X28Syq6RBfwEcxh9FE0LeKEicBarybxfA2n0I3e+ixUo
h4DiWPpCOjMbDKlzmc6OeONWpSdc49WKCmXhwkGhhT/xZH5IUahuf4JVfwHUGz7U
BRPezCCQGiN/M5NhWko9Epkro6eaafWoIeC5BtAj2IWb0wv2/o+G2yXwN6JTxHDA
sxi3tSrRMbDthvP7a0DAEEc+aeYhAuTkub/pV2bqXg6ObyDEPbbXKQjPm3uiCBPC
EUdL2st1JIWKSOVBGaLjgREaean8XLujcviWslneYQHa8XiBr6iQPB7wdyXp3Ypy
AtHgQxeiq5XbQ63TDQBeOO1tYMbP6NZj39Q8WiM+2CVAaYQUoHC04XjBfWmjInUp
5lhJdqMrOvDrGEOzd5qsKSopDpfJbSiUje8AZ0fvnDuDG9hbydZokTDE86dlJ+aL
bqZOgpUDZRmVZptLVRSZ
=2qFR
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Nov_2013_10_40_55_+1100_h6tB05xROksXPu7t--
