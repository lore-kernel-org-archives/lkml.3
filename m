Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaJFWWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 18:22:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaJFWWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 18:22:17 -0400
Date: Tue, 7 Oct 2014 00:22:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] doc for 3.18 merge window
Message-ID: <alpine.LNX.2.00.1410070008540.31343@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/doc.git for-linus

to receive

- updates to kernel documentation. I took this over (hopefully 
  temporarily) from Randy who was not willing to maintain it any
  longer. This pile mostly is a relay of queue that Randy already had
  in his tree.

----------------------------------------------------------------
Jiri Kosina (1):
      MAINTAINERS: update location of linux-doc tree

Liu Hua (1):
      Documentation: correct parameter error for dma_mapping_error

Mark Brown (1):
      v4l2-pci-skeleton: Only build if PCI is available

Mark Rutland (1):
      Docs: this_cpu_ops: remove redundant add forms

Michael Opdenacker (1):
      Documentation: fix broken v4l-utils URL

Peter Foley (12):
      Documentation: use subdir-y to avoid unnecessary built-in.o files
      Documentation: add makefiles for more targets
      Documentation: make functions static to avoid prototype warnings
      Documentation: fix misc. warnings
      Documentation: support glibc versions without htole macros
      Documentation: update .gitignore files
      Documentation: update vDSO makefile to build portable examples
      Documentation: disable vdso_test to avoid breakage with old glibc
      Make Documenation depend on headers_install
      tools: add more endian.h macros
      Documentation: remove networking/.gitignore
      Documentation: update include path for mpssd

 Documentation/.gitignore                           |  7 ---
 Documentation/DMA-API-HOWTO.txt                    |  6 +--
 Documentation/DocBook/media/v4l/common.xml         |  2 +-
 Documentation/Makefile                             |  7 +--
 Documentation/accounting/Makefile                  |  3 --
 Documentation/arm/Makefile                         |  1 +
 Documentation/arm/SH-Mobile/.gitignore             |  1 +
 Documentation/arm/SH-Mobile/Makefile               | 11 ++---
 Documentation/arm/SH-Mobile/vrl4.c                 |  7 +--
 Documentation/auxdisplay/Makefile                  |  3 --
 Documentation/blackfin/Makefile                    |  7 +--
 Documentation/filesystems/.gitignore               |  1 +
 Documentation/filesystems/Makefile                 |  3 +-
 Documentation/ia64/Makefile                        |  3 --
 Documentation/laptops/.gitignore                   |  2 +
 Documentation/laptops/Makefile                     |  5 +-
 Documentation/mic/Makefile                         |  1 +
 Documentation/mic/mpssd/Makefile                   | 24 +++++-----
 Documentation/mic/mpssd/mpssd.c                    |  5 +-
 Documentation/misc-devices/Makefile                |  1 +
 Documentation/misc-devices/mei/Makefile            |  3 --
 Documentation/networking/.gitignore                |  0
 Documentation/networking/Makefile                  |  8 +---
 Documentation/networking/timestamping/.gitignore   |  1 +
 Documentation/networking/timestamping/Makefile     |  8 +---
 Documentation/pcmcia/Makefile                      |  3 --
 Documentation/prctl/.gitignore                     |  3 ++
 Documentation/prctl/Makefile                       |  8 ++++
 .../prctl/disable-tsc-ctxt-sw-stress-test.c        | 11 +++--
 .../prctl/disable-tsc-on-off-stress-test.c         |  7 +--
 Documentation/prctl/disable-tsc-test.c             |  5 +-
 Documentation/ptp/.gitignore                       |  1 +
 Documentation/ptp/Makefile                         |  8 ++++
 Documentation/ptp/testptp.c                        |  6 +--
 Documentation/ptp/testptp.mk                       | 33 -------------
 Documentation/spi/Makefile                         |  3 --
 Documentation/this_cpu_ops.txt                     |  2 -
 Documentation/timers/.gitignore                    |  1 +
 Documentation/timers/Makefile                      |  3 --
 Documentation/vDSO/.gitignore                      |  2 +
 Documentation/vDSO/Makefile                        | 12 +++++
 Documentation/video4linux/.gitignore               |  1 -
 Documentation/video4linux/Makefile                 |  1 +
 Documentation/watchdog/Makefile                    |  1 +
 Documentation/watchdog/src/Makefile                |  3 --
 MAINTAINERS                                        |  1 +
 Makefile                                           |  2 +
 drivers/media/rc/keymaps/Kconfig                   |  2 +-
 drivers/media/v4l2-core/Kconfig                    |  9 ++++
 tools/include/tools/endian.h                       | 56 ++++++++++++++++++++++
 50 files changed, 168 insertions(+), 136 deletions(-)
 delete mode 100644 Documentation/.gitignore
 create mode 100644 Documentation/arm/Makefile
 create mode 100644 Documentation/arm/SH-Mobile/.gitignore
 create mode 100644 Documentation/filesystems/.gitignore
 create mode 100644 Documentation/laptops/.gitignore
 create mode 100644 Documentation/mic/Makefile
 create mode 100644 Documentation/misc-devices/Makefile
 delete mode 100644 Documentation/networking/.gitignore
 create mode 100644 Documentation/prctl/.gitignore
 create mode 100644 Documentation/prctl/Makefile
 create mode 100644 Documentation/ptp/.gitignore
 create mode 100644 Documentation/ptp/Makefile
 delete mode 100644 Documentation/ptp/testptp.mk
 create mode 100644 Documentation/timers/.gitignore
 create mode 100644 Documentation/vDSO/.gitignore
 create mode 100644 Documentation/vDSO/Makefile
 delete mode 100644 Documentation/video4linux/.gitignore
 create mode 100644 Documentation/video4linux/Makefile
 create mode 100644 Documentation/watchdog/Makefile
 create mode 100644 tools/include/tools/endian.h

-- 
Jiri Kosina
SUSE Labs
