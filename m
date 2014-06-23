Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbaFWPuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:50:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49698 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756027AbaFWPuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:50:05 -0400
Date: Mon, 23 Jun 2014 17:49:34 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: wim@iguana.be, Arnd Bergmann <arnd@arndb.de>, dbaryshkov@gmail.com,
        dwmw2@infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog
 driver
Message-ID: <20140623154934.GG19730@lukather>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com>
 <1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com>
 <20140507213318.GA2105@roeck-us.net>
 <20140515091123.GQ29258@lukather>
 <20140519150422.GA27329@lukather>
 <20140522203444.GE27329@lukather>
 <20140522211207.GA28704@roeck-us.net>
 <20140623103142.GB19730@lukather>
 <53A83A20.6090800@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HkfZ6fDZyisrdUtK"
Content-Disposition: inline
In-Reply-To: <53A83A20.6090800@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HkfZ6fDZyisrdUtK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2014 at 07:30:56AM -0700, Guenter Roeck wrote:
> >>The patches _are_ in my watchdog-next branch and get some coverage from
> >>both my auto-builders and from Fenguang's build robots, so while they a=
re
> >>not in linux-next, they are not completely in the dark either.
> >
> >So, this patch finally didn't make it into 3.16. Great. Now, we can't
> >even reboot the boards.
> >
> >Given how it's just impossible to get something merged reliably
> >through the watchdog tree, I guess I should just start merging the
> >patches through mine?
> >
>=20
> You can not really blame Wim here.
>=20
> In this case, I suspect the major reason for not accepting the patch
> is that I tried to provide a clean method / API for "reset through watchd=
og
> subsystem", which went nowhere, in my understanding because someone objec=
ted
> that it would be the wrong thing to do [1] and it didn't get approval /
> acceptance from the arm maintainers. If it is wrong to reset the board
> from the watchdog subsystem in a clean way, it is for sure even more wrong
> to do it as you proposed in your patch.
>=20
> My conclusion therefore is that all board reset code should move back out
> of the watchdog subsystem, and that we should not accept such code in the
> future. This is not my personal preference, but I do believe that we shou=
ld
> do it in a clean way or not at all.

Well, considering that this patch isn't depending on your reboot API
set, and that Wim never either commented on this patch, your reboot
API patchset or your pull request to say that he was not willing to
merge this, there's still a huge failure to communicate.

I'm fine with any technical reason, let's debate on that. But the
point is there has been no debate at all, only silence from his side.

I have been told some patches would be merged and I merged through my
tree some patches that were depending on this one based on that
assumption.

And now, we have a regression.

Anyway... I guess I should just revert some commits now.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--HkfZ6fDZyisrdUtK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqEyOAAoJEBx+YmzsjxAg77QP/1zJd1jlu929H8oX+wfrF0sk
bsjm/c0w4Z18EkL8vIlzhisz6HJMl9FHw/Un+kO6zKkOnHDetr64xYGjitzc3ySR
+gSY9vrGwE9hY+0mkuzgxvvZwBEqyKQTywxb/K8XAZFPiZEFY6+6RBpw+ukolkx4
MFbABXONF8HPmdKkIAeoTpzU/CCpw268P2RgGWQ2CB4luqW2IHnahPbzQ330XpS4
1GJB1D+D77sI0pDtYSq4Zh6tY5TcCiCJ8kZh3EBFgLYC4aLwns1987d6LRhRNwKJ
PGgyUiFRdx3RKBTmy1a1BpdPkLpcPAvo3FtwzBXrre7QDF7fTBMRItOmtR61ibjs
9FxOHgH/yy/rpuMVHM4UHEpRKAAAW+PDWMWCspTl9XKMcY7c07yRUorkHBwOuuwM
PbeJank8wz32M2suRt+LPCOzoP9W8S0D276GNceWGn8J8fs5h4PQ6vE2iX7H9kDS
1Jz34LjZ26K1J0ryUksdWjnY+VsjVSF7VBssf6OIe5TCcBb8nhYdTC+fScMUVMFQ
24WnWg4JUKYDZycP2PgnlZqxqYPyS3Ch98VrE7bOEUwecTzY0q8eDhm4jD8Tm6av
EDqofh251Qk7DZnZ3+uyPKJEX1iJ48Ma9pihYoTLm2fA+LqVhMnnmFvEZG/Jo4Vm
Iy5Dhr/Xk6RLZEDfiTyp
=KVeb
-----END PGP SIGNATURE-----

--HkfZ6fDZyisrdUtK--
