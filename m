Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab3FRVrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:47:51 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:38199 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab3FRVru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:47:50 -0400
Date: Tue, 18 Jun 2013 23:47:02 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
        Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH V3 0/6] FMC: resending unapplied patches
Message-ID: <cover.1371591538.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Six patches from the series I initially sent on Jun 12.

Changes in V3: all 6 yet unapplied by greg are resent, in correct order.

Changes in V2: turned a generic "public domain" note for code to be
reused into a proper BSD-like license, but I only resent affected
patches, in error.

Alessandro Rubini (6):
  FMC: add core bus driver
  FMC: add documentation for the core
  FMC: add a software carrier driver
  FMC: add a software mezzanine driver
  FMC: add a driver to write mezzanine EEPROM
  FMC: add a char-device mezzanine driver

 Documentation/00-INDEX                 |    2 +
 Documentation/fmc/00-INDEX             |   38 ++++
 Documentation/fmc/API.txt              |   47 +++++
 Documentation/fmc/FMC-and-SDB.txt      |   88 ++++++++
 Documentation/fmc/carrier.txt          |  311 ++++++++++++++++++++++++++++
 Documentation/fmc/fmc-chardev.txt      |   64 ++++++
 Documentation/fmc/fmc-fakedev.txt      |   36 ++++
 Documentation/fmc/fmc-trivial.txt      |   17 ++
 Documentation/fmc/fmc-write-eeprom.txt |  125 +++++++++++
 Documentation/fmc/identifiers.txt      |  168 +++++++++++++++
 Documentation/fmc/mezzanine.txt        |  123 +++++++++++
 Documentation/fmc/parameters.txt       |   56 +++++
 drivers/fmc/Kconfig                    |   34 +++
 drivers/fmc/Makefile                   |    9 +
 drivers/fmc/fmc-chardev.c              |  197 ++++++++++++++++++
 drivers/fmc/fmc-core.c                 |  274 ++++++++++++++++++++++++-
 drivers/fmc/fmc-dump.c                 |  100 +++++++++
 drivers/fmc/fmc-fakedev.c              |  355 ++++++++++++++++++++++++++++++++
 drivers/fmc/fmc-match.c                |  114 ++++++++++
 drivers/fmc/fmc-sdb.c                  |  265 ++++++++++++++++++++++++
 drivers/fmc/fmc-trivial.c              |  107 ++++++++++
 drivers/fmc/fmc-write-eeprom.c         |  176 ++++++++++++++++
 drivers/fmc/fru-parse.c                |   82 ++++++++
 23 files changed, 2787 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/fmc/00-INDEX
 create mode 100644 Documentation/fmc/API.txt
 create mode 100644 Documentation/fmc/FMC-and-SDB.txt
 create mode 100644 Documentation/fmc/carrier.txt
 create mode 100644 Documentation/fmc/fmc-chardev.txt
 create mode 100644 Documentation/fmc/fmc-fakedev.txt
 create mode 100644 Documentation/fmc/fmc-trivial.txt
 create mode 100644 Documentation/fmc/fmc-write-eeprom.txt
 create mode 100644 Documentation/fmc/identifiers.txt
 create mode 100644 Documentation/fmc/mezzanine.txt
 create mode 100644 Documentation/fmc/parameters.txt
 create mode 100644 drivers/fmc/fmc-chardev.c
 create mode 100644 drivers/fmc/fmc-dump.c
 create mode 100644 drivers/fmc/fmc-fakedev.c
 create mode 100644 drivers/fmc/fmc-match.c
 create mode 100644 drivers/fmc/fmc-sdb.c
 create mode 100644 drivers/fmc/fmc-trivial.c
 create mode 100644 drivers/fmc/fmc-write-eeprom.c
 create mode 100644 drivers/fmc/fru-parse.c

-- 
1.7.7.2
