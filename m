Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaKYTnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:43:37 -0500
Received: from smtp.outflux.net ([198.145.64.163]:57774 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbaKYTng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:43:36 -0500
Date: Tue, 25 Nov 2014 11:43:19 -0800
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pranith Kumar <bobby.prani@gmail.com>
Subject: [PULL] seccomp update (next)
Message-ID: <20141125194319.GA9328@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please pull these seccomp changes for next.

Thanks!

-Kees

The following changes since commit 5d01410fe4d92081f349b013a2e7a95429e4f2c9:

  Linux 3.18-rc6 (2014-11-23 15:25:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/seccomp-next

for you to fetch changes up to cb24de187b9a0717246f05afc0f2be070e075d80:

  seccomp: Replace smp_read_barrier_depends() with lockless_dereference() (2014-11-25 11:40:24 -0800)

----------------------------------------------------------------
Improves SMP dereferencing with new macro.

----------------------------------------------------------------
Pranith Kumar (1):
      seccomp: Replace smp_read_barrier_depends() with lockless_dereference()

 kernel/seccomp.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

-- 
Kees Cook
Chrome OS Security
