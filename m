Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965530AbaH0XnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:43:19 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:43930
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964814AbaH0XnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:43:16 -0400
Date: Thu, 28 Aug 2014 01:43:14 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org,
        linux-security-module@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [security-next] Pull request (merge window)
Message-ID: <20140827234314.GA29562@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/linux-security sec-v3.17-rc2

for you to fetch changes up to 8fe7a268b18ebc89203c766b020b9e32f1cfeebf:

  tomoyo: Fix pathname calculation breakage. (2014-08-26 21:52:09 -0500)

- ----------------------------------------------------------------
Tetsuo Handa (1):
      tomoyo: Fix pathname calculation breakage.

 security/tomoyo/realpath.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJT/mw0AAoJELF1z6mPGSryE80H/32KcZ50yKf8BdQ8TzcvNQQf
pOFkdJsekS6YUQDRN22Qcf2tBHGI2YjaALN0xiPfhHNbXFNzDzpklGXEz6NU58DT
t1i9jXB4Ks8+ydl5MU3zPpsuEdcOBuIPv40E5fWi7jS3X27RjerKgiD0h+nGtbpT
mbF2KskQx6oAF5MpKkb/2fYzopkcwwZtn8GNjU6mhz74ndenluuN6Z8t39RRjzkd
1lb+3yOefpMjQZ3KCjEddmcwHw8EFOL0UvUfV18FXV7FaUoNaeNGqWW6xIvm2PH1
clj9KifHg0D2RrKaxO1mKQRvfDkzwnFw/yTBtC+w3SXxtmXgQa+0iY/WVh02jXA=
=VO9O
-----END PGP SIGNATURE-----
