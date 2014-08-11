Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbaHKUeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 16:34:22 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44943 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670AbaHKUeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 16:34:21 -0400
Date: Mon, 11 Aug 2014 13:34:15 -0700
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Kees Cook <keescook@chromium.org>
Subject: [PULL] for-linus-seccomp update (for-linus-seccomp-3.17)
Message-ID: <20140811203415.GA6150@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Please pull these for-linus-seccomp changes for for-linus-seccomp-3.17. Thanks!

-Kees

The following changes since commit c8d6637d0497d62093dbba0694c7b3a80b79bfe1:

  Merge tag 'modules-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux (2014-08-10 21:31:58 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/for-linus-seccomp-for-linus-seccomp-3.17

for you to fetch changes up to 69f6a34bdeea4fec50bb90619bc9602973119572:

  seccomp: Replace BUG(!spin_is_locked()) with assert_spin_lock (2014-08-11 13:29:12 -0700)

----------------------------------------------------------------
Building UP on some archs makes spin_is_locked return 0, which will BUG
at boot with seccomp enabled.

----------------------------------------------------------------
Guenter Roeck (1):
      seccomp: Replace BUG(!spin_is_locked()) with assert_spin_lock

 kernel/fork.c    |  2 +-
 kernel/seccomp.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

-- 
Kees Cook
Chrome OS Security
