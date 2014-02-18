Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaBRSWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:22:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbaBRSWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:22:54 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        devel@acpica.org, mingo@redhat.com, ck@conrad-kostecki.de,
        tglx@linutronix.de, trenn@suse.de
Subject: ACPI: Also allow ACPI table adding via initrd not only overriding
Date: Tue, 18 Feb 2014 19:22:39 +0100
Message-Id: <1392747763-3384-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <530265A3.3020302@zytor.com>
References: <530265A3.3020302@zytor.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPICA patches have to go into separate acpica repository first.
It should also be checked in acpica whether the table signature the OS likes
to add already exists (from BIOS). In this case the table must not be added.

Worked here by trying to override a DSDT and addind a BGRT table.

     Thomas

