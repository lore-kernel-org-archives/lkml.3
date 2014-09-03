Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbaICWMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:12:42 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59813 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898AbaICWMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:12:38 -0400
Date: Wed, 3 Sep 2014 15:12:31 -0700
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: [PULL] seccomp update (3.18)
Message-ID: <20140903221231.GA21608@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please pull these seccomp changes for 3.18.

Thanks!

-Kees

The following changes since commit c3ce6dfa48e3879206382cdfdc015bffc50dce30:

  KEYS: Set pr_fmt() in asymmetric key signature handling (2014-09-03 11:08:45 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/seccomp-3.18

for you to fetch changes up to a0cfd75fdc46b56978ece383a7d6f6b04e9087ad:

  seccomp: Add reviewers to MAINTAINERS (2014-09-03 15:09:54 -0700)

----------------------------------------------------------------
adding reviewers

----------------------------------------------------------------
Kees Cook (1):
      seccomp: Add reviewers to MAINTAINERS

 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

-- 
Kees Cook
Chrome OS Security
