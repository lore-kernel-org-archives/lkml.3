Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3JAQ76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:59:58 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33734 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752408Ab3JAQ7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:59:55 -0400
Message-ID: <524AFF89.4080703@hurleysoftware.com>
Date: Tue, 01 Oct 2013 12:59:53 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: 3.12.0-rc3: Symbol license change in commit caf5c03f (ACPI: Move
 acpi_bus_get_device() from bus.c to scan.c)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have no love lost for proprietary modules but changing
acpi_bus_get_device() symbol's license seems gratuitous considering
the symbol pre-dates the mainline git tree and the code is just
being moved from one source file to another.

Regards,
Peter Hurley
