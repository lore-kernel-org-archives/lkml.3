Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162347Ab3DERAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:00:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34772 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162142Ab3DERAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:00:34 -0400
Date: Fri, 5 Apr 2013 18:00:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Sound fixes for 3.9-rc6
Message-ID: <20130405170030.GM6597@opensource.wolfsonmicro.com>
References: <s5hzjxd2zec.wl%tiwai@suse.de>
 <CA+55aFzeB+75fSQZzqiNdN7JdcNd0qAxWeZuCm9h8Znh+wdZ3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z/kiM2A+9acXa48/"
Content-Disposition: inline
In-Reply-To: <CA+55aFzeB+75fSQZzqiNdN7JdcNd0qAxWeZuCm9h8Znh+wdZ3A@mail.gmail.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z/kiM2A+9acXa48/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 05, 2013 at 09:06:43AM -0700, Linus Torvalds wrote:

> Argh, Takashi, you're usually so reliable...

> But you actually meant for me to pull the sound-3.9 tag, didn't you?
> That "for-linus" branch isn't a signed tag..

> Please double-check your scripts,

Probably needs a git upgrade - for a while git would silently substitute
a branch if it had the same head as a signed tag when generating pull
requests (which was very annoying if you'd had a public branch which you
were just getting round to signing).  Current versions should get this
right and insist on the tag if that was what was supplied on the command
line.

--Z/kiM2A+9acXa48/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXwMoAAoJELSic+t+oim9aWcP/09q5262hf/4rJqUbPANId5J
+tWlS9lQj7nKJqxr8kR9ZKVkfHqClP9sMaIJprfQnYb1eMNDZST9ToeWu6zTFDFp
nESDahznADkrQ1AdpD8gRwzpauw9d4P7TeWAYz2aqKnpwtADixwd2uL3pywZfBoe
2a5T26c5snZlv+TYpRrfO8N+9GFmQ+xF1+YC0ZotkRu4AnD1aaakvOFRwGMNOKiv
z0oFc8deldH5+DkLYV5fuStqX24sMXuJbtOW1IkbFDrYHlACGg9XWGjkCXfbKOpk
S6Lx2hD/S/VEjEqzFazANn+mnCQlqpIxWBJEU2lSVlutYLzPVh2kjF8AulzfcYE/
EndQeVVPZ+BWa73ogDaElm5rf/YBZfHVz5eptoYGOZYb2HDm3l75GjmNQYacB81u
+k4jg5oVbn8HBNs4wYibQvqlVyLujXSx8CAmewvgPxOu47TIRKr0SJrZATawpUig
x724Lws72RMZTiMIR6Rpxd25sN2raV1jTVZVOS13UGrh7f/bkoT7h8nN3fp5rZ3Z
KAQmCLQnqML5JLdcCWgnL3I/G/JHJbwtRg9mGrjRKStBzstJeeJMeaM77tPgUC3K
ZaKey220kV/fx3T+/4DWdgowfZuCv/nNdHSj3SQb1hMu3L7rljllq6uHixmHmtKt
3AKyujObqQQjAU41YVzS
=tN2U
-----END PGP SIGNATURE-----

--Z/kiM2A+9acXa48/--
