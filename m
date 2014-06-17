Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966915AbaFQWk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:40:57 -0400
Received: from ozlabs.org ([103.22.144.67]:35888 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965424AbaFQWkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:40:55 -0400
Date: Wed, 18 Jun 2014 08:40:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: the selinux tree needs cleaning up
Message-ID: <20140618084046.1bce12cc@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/mpC1UCafwyvkeyBMK41XvF4"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mpC1UCafwyvkeyBMK41XvF4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

The selinux tree (git://git.infradead.org/users/pcmoore/selinux#next)
contains some commits going back to January and also has merges of
v3.13, v3.14 and v3.15 in it.  If you rebase that tree onto v3.16-rc1,
you find that it has onlt 2 unique commits (the most recent 2) which
means that the others were merged upstream after being rewritten.  :-(

Please clean this up.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/mpC1UCafwyvkeyBMK41XvF4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJToMP0AAoJEMDTa8Ir7ZwVV8UP/RbVpgHfvJ3x+08+M0CxV38m
6BcsoD/DiOLHoE14KSdjwPhT5cF6aVpjW0lxeuOT4O2pjyuSR7HxXo8krzNgU2zB
rc+XnWvN367w68uhlCPithA7AwqhCxYBwHXuo7fLnEt6kmFmA9x9hm+iChgpGsmw
EzG+8SkHBO0dNQGD1Ui3kPLHGqfDHCQaRfZLdI8izGnht7WlK7ZSpKk2lgHn96fQ
4RhjIgsvkD4nFY/RSF9cyhQawml4Yb/VsjotW3R3POVa97eCWPLhcbSObiUMO7hu
+j+hkbd1fv6l3+dPPZODtQ/3rGC5GiBuh6Dwue1u33UIJdqrAbl0eh813bcoQITf
L7l+GOhQe45NKcXYCDHvsp6crUIu38/1MfrbeJt4Ad/OgVVsJ4t9rIXvVmSOLWwE
P/PCWnlo6ZejeSWQxqzOLIY18VuaAbtqJdrYsc5PPKeiSfYhLELX3pEDWCwvbP+Q
VyfQxUqzmhyREZ3iSktLNKR32GI1A8IfKNR0UtZROiXqFaRu2Ja1J/eOC6qPQiAY
6+pyAxKbAd9giiG+JmrX5qUoTHAa1umlhqNW1nJF0pNbqGOe/gntiOV8F9YJ9Zmt
6cpLU+qgHTjYpRIPknJq9gLbUu2VS1dX8tHL2bTA3wAjS0VjG9rCIh6JmvfOS3F9
V3LblGemn7tEjY09HdhY
=0PR1
-----END PGP SIGNATURE-----

--Sig_/mpC1UCafwyvkeyBMK41XvF4--
