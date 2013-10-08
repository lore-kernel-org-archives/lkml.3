Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab3JHXnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 19:43:09 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53183 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756275Ab3JHXnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 19:43:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>
Subject: [PATCH 2/2] MAINTAINERS / ACPI: Update links and git tree information
Date: Wed, 09 Oct 2013 01:53:52 +0200
Message-ID: <1620342.eXKkFMTZcl@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1551451.ka7cHHvmPr@vostro.rjw.lan>
References: <1551451.ka7cHHvmPr@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Update the ACPI subsystem's git tree and Web links in the
MAINTAINERS file.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-pm/MAINTAINERS
===================================================================
--- linux-pm.orig/MAINTAINERS
+++ linux-pm/MAINTAINERS
@@ -239,9 +239,9 @@ ACPI
 M:	Len Brown <lenb@kernel.org>
 M:	Rafael J. Wysocki <rjw@rjwysocki.net>
 L:	linux-acpi@vger.kernel.org
-W:	http://www.lesswatts.org/projects/acpi/
-Q:	http://patchwork.kernel.org/project/linux-acpi/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux
+W:	https://01.org/linux-acpi
+Q:	https://patchwork.kernel.org/project/linux-acpi/list/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
 S:	Supported
 F:	drivers/acpi/
 F:	drivers/pnp/pnpacpi/

