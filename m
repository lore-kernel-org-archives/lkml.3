Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab3FRV1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:27:52 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:38149 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932799Ab3FRV1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:27:51 -0400
Date: Tue, 18 Jun 2013 23:27:02 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
        Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH V2 0/2] FMC: resend sample drivers
Message-ID: <cover.1371589927.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Greg-KH [1] I'm resending the two example submodules
(one carrier driver and one mezzanine driver) with a proper licence
text for BSD. Among the various wordings, I chose the shortest one, as
used by a number of drivers/net/wireless/ files.  Thank you David for
checking the distribution policies.

I rebased to next-20130617 and rebuilt, with no conflicts. In any
of the patches of the original series.

[1] https://lkml.org/lkml/2013/6/17/772:
    "Just redo those two patches and send them as 'v2'")

Alessandro Rubini (2):
  FMC: add a software carrier driver
  FMC: add a software mezzanine driver

 Documentation/fmc/00-INDEX        |    6 +
 Documentation/fmc/fmc-fakedev.txt |   36 ++++
 Documentation/fmc/fmc-trivial.txt |   17 ++
 drivers/fmc/Kconfig               |   18 ++
 drivers/fmc/Makefile              |    3 +
 drivers/fmc/fmc-fakedev.c         |  355 +++++++++++++++++++++++++++++++++++++
 drivers/fmc/fmc-trivial.c         |  107 +++++++++++
 7 files changed, 542 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/fmc/fmc-fakedev.txt
 create mode 100644 Documentation/fmc/fmc-trivial.txt
 create mode 100644 drivers/fmc/fmc-fakedev.c
 create mode 100644 drivers/fmc/fmc-trivial.c

-- 
1.7.7.2
