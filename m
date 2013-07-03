Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3GCMgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:36:45 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53622 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab3GCMgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:36:43 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>
Subject: 3.10: Intel HWMON/NIC temperature sensor question
Date: Wed, 3 Jul 2013 08:36:40 -0400
Message-ID: <002d01ce77e9$f86e0c10$e94a2430$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac536fIqXnlopYMJTRaY0Psj+FTZAg==
Content-language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I saw this in the device drive section and was curious which Intel-based
NICs contain temperature sensors?

Intel(R) 10GbE PCI Express adapters HWMON support
Intel(R) PCI-Express Gigabit adapters HWMON support

I checked the boards below and none appear to expose a hwmon interface:
08:00.0 Ethernet controller: Intel Corporation 82580 Gigabit Network
Connection (rev 01)
08:00.1 Ethernet controller: Intel Corporation 82580 Gigabit Network
Connection (rev 01)
08:00.2 Ethernet controller: Intel Corporation 82580 Gigabit Network
Connection (rev 01)
08:00.3 Ethernet controller: Intel Corporation 82580 Gigabit Network
Connection (rev 01)
09:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network
Connection
0a:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network
Connection
01:00.0 Ethernet controller: Intel Corporation 82598EB 10-Gigabit AT2 Server
Adapter (rev 01)

# find /sys/|grep hwmon

Radeon:
/sys/devices/pci0000:00/0000:00:03.1/0000:05:00.0/hwmon
/sys/devices/pci0000:00/0000:00:03.1/0000:05:00.0/hwmon/hwmon0
/sys/devices/pci0000:00/0000:00:03.1/0000:05:00.0/hwmon/hwmon0/name
/sys/devices/pci0000:00/0000:00:03.1/0000:05:00.0/hwmon/hwmon0/power
/sys/devices/pci0000:00/0000:00:03.1/0000:05:00.0/hwmon/hwmon0/power/control
/sys/devices/pci0000:00/0000:00:03.1/0000:05:00.0/hwmon/hwmon0/power/runtime
_active_time
/sys/devices/pci0000:00/0000:00:03.1/0000:05:00.0/hwmon/hwmon0/power/autosus
pend_delay_ms
/sys/devices/pci0000:00/0000:00:03.1/0000:05:00.0/hwmon/hwmon0/power/runtime
_status
/sys/devices/pci0000:00/0000:00:03.1/0000:05:00.0/hwmon/hwmon0/power/runtime
_suspended_time
/sys/devices/pci0000:00/0000:00:03.1/0000:05:00.0/hwmon/hwmon0/device
/sys/devices/pci0000:00/0000:00:03.1/0000:05:00.0/hwmon/hwmon0/subsystem
/sys/devices/pci0000:00/0000:00:03.1/0000:05:00.0/hwmon/hwmon0/uevent
/sys/devices/pci0000:00/0000:00:03.1/0000:05:00.0/hwmon/hwmon0/temp1_input

Onboard chipset:
/sys/devices/platform/nct6775.2608/hwmon
/sys/devices/platform/nct6775.2608/hwmon/hwmon2
/sys/devices/platform/nct6775.2608/hwmon/hwmon2/power
/sys/devices/platform/nct6775.2608/hwmon/hwmon2/power/control
/sys/devices/platform/nct6775.2608/hwmon/hwmon2/power/runtime_active_time
/sys/devices/platform/nct6775.2608/hwmon/hwmon2/power/autosuspend_delay_ms
/sys/devices/platform/nct6775.2608/hwmon/hwmon2/power/runtime_status
/sys/devices/platform/nct6775.2608/hwmon/hwmon2/power/runtime_suspended_time
/sys/devices/platform/nct6775.2608/hwmon/hwmon2/device
/sys/devices/platform/nct6775.2608/hwmon/hwmon2/subsystem
/sys/devices/platform/nct6775.2608/hwmon/hwmon2/uevent

CPU:
/sys/devices/platform/coretemp.0/hwmon
/sys/devices/platform/coretemp.0/hwmon/hwmon1
/sys/devices/platform/coretemp.0/hwmon/hwmon1/power
/sys/devices/platform/coretemp.0/hwmon/hwmon1/power/control
/sys/devices/platform/coretemp.0/hwmon/hwmon1/power/runtime_active_time
/sys/devices/platform/coretemp.0/hwmon/hwmon1/power/autosuspend_delay_ms
/sys/devices/platform/coretemp.0/hwmon/hwmon1/power/runtime_status
/sys/devices/platform/coretemp.0/hwmon/hwmon1/power/runtime_suspended_time
/sys/devices/platform/coretemp.0/hwmon/hwmon1/device
/sys/devices/platform/coretemp.0/hwmon/hwmon1/subsystem
/sys/devices/platform/coretemp.0/hwmon/hwmon1/uevent

Justin.



