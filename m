Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3IAXqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 19:46:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36062 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab3IAXql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 19:46:41 -0400
Date: Mon, 2 Sep 2013 09:46:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Please add
 git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git
 branch h8300-remove to linux-next
Message-Id: <20130902094629.4450871f9e7276a855d04a72@canb.auug.org.au>
In-Reply-To: <52213228.3050308@roeck-us.net>
References: <52213228.3050308@roeck-us.net>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Sep_2013_09_46_29_+1000_8mTF50iB92G1z1l0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Sep_2013_09_46_29_+1000_8mTF50iB92G1z1l0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Fri, 30 Aug 2013 17:00:40 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>
> Please add the h8300-remove branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git
> to linux-next.

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

--Signature=_Mon__2_Sep_2013_09_46_29_+1000_8mTF50iB92G1z1l0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSI9HZAAoJEECxmPOUX5FE2xoP/3kJwfcfAGA+w1Bgl3niqeeB
E2Ocvs+yPfXtUhzASA7fG4rVrxDNmS7aVDs5RUCBBaaqYE5T3as6fjZYspYK8wub
udpT0RWCYU3pjYgeKwa2dk1+iNLQqbCL1pMxhoK67TVzq8aMK5JnSkzqvZvgxKXo
yvKviVvvX2AvGVhxsYAy4cw9GNtrD5Cu2gGvgnhXVFV8zmw7hl4i/633WRr9F54i
bWO6FpC9NsAyvOPpHJQAXDAxbHTTDYhmqUZvajsinFCV+M9KwvrDMPfqloVbZUmu
2NMouYqg444rM3IugT3rYsrYg/63RIgE3Epa4x7BRchKCZcXVo5MK3RbFIEFCOZQ
a+RGFUdR29rcYfD5qhnt8ai7BOrGOvYZMTNkd3jTwy5XClHI9zac/F16yBkmK2vu
jKOmuSapAeLHNG9le0MjXm3CWyvIuBAfkxXEDAyCGUPFoMDe0DwII4Eyv/txyhuR
ca6/A3sQtq0sAX3IHZBg0IOPKzRPAWFdEZZaHRXsySl/1p4VXyh6MvwQVgWb3AQN
xP38k00HZpFjuz3X+wcB23Q4vnxNIbYXcfvZLyL93WN7BJpPTjStdEeIP8gWY7dT
GdjqMu0673yQTIoE7qeDM6cWpJ2AHDW9p02eyFYdu087hXonvncN8oXu0igwy6Pf
eko458n15bOjqUraYi95
=6jbQ
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Sep_2013_09_46_29_+1000_8mTF50iB92G1z1l0--
