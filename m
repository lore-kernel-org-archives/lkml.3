Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161079AbaDPNYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:24:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:6600 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589AbaDPNYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:24:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,872,1389772800"; 
   d="scan'208";a="521624280"
From: Lan Tianyu <tianyu.lan@intel.com>
To: wsa@the-dreams.de, rjw@rjwysocki.net, lenb@kernel.org,
        mika.westerberg@linux.intel.com, awilliam@redhat.com,
        tianyu.lan@intel.com
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] I2C ACPI operation region handler support 
Date: Wed, 16 Apr 2014 21:24:33 +0800
Message-Id: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI 5.0 spec(5.5.2.4.5) defines GenericSerialBus(i2c, spi, uart) operation
region. It allows ACPI aml code able to access such kind of devices to
implement some ACPI standard method.

On the Asus T100TA, Bios use GenericSerialBus operation region to access
i2c device to get battery info. So battery function depends on the I2C
operation region support. Here is the bug link.
https://bugzilla.kernel.org/show_bug.cgi?id=69011

This patchset is to add I2C ACPI operation region handler support.

[PATCH 1/9] ACPICA: Executer: Fix buffer allocation issue for
[PATCH 2/9] ACPICA: Export acpi_buffer_to_resource symbol
[PATCH 3/9] ACPI: Add acpi_bus_attach_private_data() to facilitate to
[PATCH 4/9] ACPI/Thermal: Use acpi_bus_attach_private_data() to
[PATCH 5/9] I2C: Add smbus quick read/write helper function
[PATCH 6/9] I2C: Add smbus word/block process call helper function
[PATCH 7/9] I2C/ACPI: Add i2c ACPI operation region support
[PATCH 8/9] I2C/ACPI: Move ACPI related code to i2c-acpi.c
[PATCH 9/9] I2C/ACPI: Add CONFIG_I2C_ACPI config
