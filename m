Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3AVVLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:11:19 -0500
Received: from mout.gmx.net ([212.227.17.20]:59230 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021Ab3AVVLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:11:14 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/T0fs4WvrT5SkMWEIC/fcLnsr8Y3KCUIpnhafj+5
	Ff+520KZsnp/r4
Message-ID: <50FF006C.7070803@gmx.de>
Date: Tue, 22 Jan 2013 22:11:08 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus <torvalds@linux-foundation.org>,
        linux-parisc <linux-parisc@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        John David Anglin <dave.anglin@bell.net>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] parisc fixes for v3.8-rc5
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please consider pulling the following 4 patches for 3.8-rc5 which improve
the stability of the linux kernel on the parisc architecture.

Only parisc arch-specfic files are changed.

Thanks,
Helge  


The following changes since commit d287b8750e47c1702dab0e37ac11012bb751ece0:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2013-01-07 09:41:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git for-linus


----------------------------------------------------------------
John David Anglin (4):
      parisc: avoid undefined shift in cnv_float.h
      parisc: don't claim cpu irqs more than once
      parisc: improve ptrace support for gdb single-step
      parisc: sigaltstack doesn't round ss.ss_sp as required

 arch/parisc/kernel/entry.S       | 18 +++++++++++++-----
 arch/parisc/kernel/irq.c         |  6 ++++--
 arch/parisc/kernel/ptrace.c      |  2 +-
 arch/parisc/kernel/signal.c      |  4 +++-
 arch/parisc/math-emu/cnv_float.h | 11 +++++------
 5 files changed, 26 insertions(+), 15 deletions(-)

