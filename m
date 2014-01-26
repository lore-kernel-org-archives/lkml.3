Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaAZLBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 06:01:49 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752396AbaAZLBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 06:01:48 -0500
Message-ID: <52E4EB19.7000502@nod.at>
Date: Sun, 26 Jan 2014 12:01:45 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] UML changes for 3.14-rc1
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus,

The following changes since commit d8ec26d7f8287f5788a494f56e8814210f0e64be:

  Linux 3.13 (2014-01-19 18:40:07 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git for-linus

for you to fetch changes up to 9e443bc369e04b8db3266d7253ce7c1eee2ec979:

  um: hostfs: make functions static (2014-01-26 11:51:09 +0100)

- ----------------------------------------------------------------
This time only various cleanups and housekeeping patches.

- ----------------------------------------------------------------
James Hogan (1):
      um: hostfs: make functions static

Richard Weinberger (2):
      um: Removed unused attributes from thread_struct
      um: Include generic barrier.h

 arch/um/include/asm/Kbuild              |  1 +
 arch/um/include/asm/processor-generic.h |  3 --
 fs/hostfs/hostfs_kern.c                 | 53 +++++++++++++++++----------------
 3 files changed, 29 insertions(+), 28 deletions(-)

Thanks,
//richard
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS5OsZAAoJEPmeIjfg4UaaOn0QAKl+fV9JoqGeR0pijA6N5HVX
lHSGDT5hW24VA3SnnE4QYEvRi6s6k8v3UPYeCQ7tfP3F/qQRXcOgvNl18BNN7kGy
Ta5OfiE0UTDAwJOv1pm8Trje8rm3+Ta+wR3JUHe6yHNOxUjU61rkmNpghvKJa+Ml
Q/ETNys+LLTaVK4ptyzjnYvYOw3H0Db1nKEIOAFO+e3zJj48OdkLBaH7wov9jG8f
lQbUTdQcOwH8XFiiRqTzavj4yjG3ckY0WlcUqL2uXmO8GF+d4+COneEVvJRh3aUt
lEbEokBeuwpB4Tl6dcnOYz2QPto1OSJqkfL3T5cRr6SumRARE8lBDEEK8fB3YqJ3
o/h3gIusS/v27I2Pc+DZ+e9T0akoToITHrK3yhCyiR6DgtgkTreu+PKMw72uEwLO
oAhklcIAD9Pg+u2TfnBPpoQUONhP/OjTvA+ZCWlHWe7Dgb9yuOX8rf2Fi7L0FngE
eJpM1Hts9VApIoFzs4dih+HGLylGCUZzk5aDI6EckfspW4OhvlAEeuvUe5rqHzUH
iTEzU9i62O36EGB+cYpW3A869t2O/hkVbUKnuXmNBj1PecITnIcwtyyi7EVzJUVt
CJcDlPpLG1SlJUiOR/TeLElAU71nIYL/Q149hYZ3TLa5koXGmY01kxFxCGnc4L1V
QClTbuQx5/bmtqknhAgw
=DJ98
-----END PGP SIGNATURE-----
