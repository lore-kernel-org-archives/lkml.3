Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaGaVbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:31:43 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:39823 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaGaVbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:31:40 -0400
MIME-Version: 1.0
Date: Thu, 31 Jul 2014 23:31:39 +0200
X-Google-Sender-Auth: epX3wZBdv9qS7LeMbBgLBQTwims
Message-ID: <CAJZ5v0jNqU12myfkpkODPnOTKpfRPcJYbS6GyKr+Rbq-fU_67g@mail.gmail.com>
Subject: [GIT PULL] ACPI PNP fix for v3.16-rc6
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.16-rc8

to receive an ACPI PNP fix for v3.16-rc8 (if there is -rc8
or for the final v3.16 otherwise) with top-most commit
b6328a07bd6b3d31b64f85864fe74f3b08c010ca

 ACPI / PNP: Fix acpi_pnp_match()

on top of commit 64aa90f26c06e1cb2aacfb98a7d0eccfbd6c1a91

 Linux 3.16-rc7

That's just one commit that fixes a problem causing PNP devices
to be associated with wrong ACPI device objects sometimes during
device enumeration due to an incorrect check in a matching function.
That problem was uncovered by the ACPI device enumeration rework
in 3.14.

Thanks!


---------------

Rafael J. Wysocki (1):
      ACPI / PNP: Fix acpi_pnp_match()

---------------

 drivers/pnp/pnpacpi/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
