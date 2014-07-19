Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbaGSUUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 16:20:32 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59632 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754635AbaGSUUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 16:20:03 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/2] ACPI / PM: Make ACPI-based PCI wakeup work for the "freeze" sleep state
Date: Sat, 19 Jul 2014 22:36:53 +0200
Message-ID: <1907495.agrCMfRsQN@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As per the subject, this is to make ACPI-based PCI wakeup (such as WoL on some
systems among other things) work with the "freeze" sleep state.  For this
purpose ACPI wakeup GPEs need to be enabled for wakeup devices before
freeze_enter() is called and it is best to do that when configuring devices
for wakeup.

[1/2] Always enable wakeup GPEs when configuring devices for wakeup
[2/2] Rename one static function to avoid possible future confusion

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
