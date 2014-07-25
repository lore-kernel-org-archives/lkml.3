Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbaGYRH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:07:28 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:43462 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbaGYRH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:07:26 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] staging: comedi: amplc_dio200 detach cleanups
Date: Fri, 25 Jul 2014 18:07:06 +0100
Message-Id: <1406308029-15712-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a double free_irq() and do a bit more cleaning up of the "detach"
routines.

1) staging: comedi: amplc_dio200_common: prevent extra free_irq()
2) staging: comedi: amplc_dio200_common: remove some tests from
   amplc_dio200_common_detach()
3) staging: comedi: amplc_dio200_pci: no need to test board pointer in
   dio200_pci_detach()

 drivers/staging/comedi/drivers/amplc_dio200_common.c | 9 +++------
 drivers/staging/comedi/drivers/amplc_dio200_pci.c    | 5 +----
 2 files changed, 4 insertions(+), 10 deletions(-)
