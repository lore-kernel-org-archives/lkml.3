Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab3G0NFf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 09:05:35 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43316 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab3G0NEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 09:04:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH 0/3] ACPI / PM: Device PM cleanups
Date: Sat, 27 Jul 2013 15:09:29 +0200
Message-ID: <10433383.dueoNg39qi@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The following 3 patches clean up ACPI device PM a bit:

[1/3] Fix acpi_device_set_power() to avoid printing useless messages for
      devices that aren't power manageable.

[2/3] Fix messages in acpi_device_set_power() to always contain a device
      name.

[3/3] Replace ACPI_STATE_D3 witn ACPI_STATE_D3_COLD everywhere in the tree
      (leave definition as part of ACPICA).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
