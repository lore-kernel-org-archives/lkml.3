Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3CBWWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 17:22:35 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:49946 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab3CBWV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 17:21:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: [PATCH 0/2] ACPI / LPSS: Clocks handling rework and LTR support
Date: Sat, 02 Mar 2013 23:26:49 +0100
Message-ID: <1878438.IOSu0hheXQ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches rework the initialization of Intel Lynxpoint LPSS
device clocks and add support for reading LTR (Latency Tolerance Reporting)
registers of those devices.

[1/2] Add special ACPI scan handler for Intel Lynxpoint LPSS devices.
[2/2] Add support for exposing the LTR registers of LPSS devices to user space.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
