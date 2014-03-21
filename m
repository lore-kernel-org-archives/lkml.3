Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966502AbaCUAW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:22:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:5735 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966084AbaCUAWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:22:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,699,1389772800"; 
   d="scan'208";a="496240032"
Message-ID: <532B8630.8030607@linux.intel.com>
Date: Fri, 21 Mar 2014 08:22:08 +0800
From: "Lu, Baolu" <baolu.lu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [asus-nb-wmi] thermal device detected by asus-nb-wmi platform driver
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I booted Ubuntu13.10 onto ASUS T100 Tablet and upgraded it with upstream
kernel (3.14.0-rc7+). There is a thermal device under
/sys/devices/platform/asus-nb-wmi.

root@t100:~/linux# tree /sys/class/hwmon/
/sys/class/hwmon/
├── hwmon0 -> ../../devices/platform/coretemp.0/hwmon/hwmon0
└── hwmon1 -> ../../devices/platform/asus-nb-wmi/hwmon/hwmon1

root@t100:/sys/devices/platform/asus-nb-wmi# ls
cpufv driver hwmon input modalias power subsystem uevent

root@t100:~/linux# sensors
coretemp-isa-0000
Adapter: ISA adapter
Core 0: +38.0°C (high = +90.0°C, crit = +90.0°C)
Core 1: +38.0°C (high = +90.0°C, crit = +90.0°C)
Core 2: +39.0°C (high = +90.0°C, crit = +90.0°C)
Core 3: +38.0°C (high = +90.0°C, crit = +90.0°C)

asus-isa-0000
Adapter: ISA adapter
temp1: +6280.0°C

I didn't get any information about thermal interface in
"Documentation/ABI/testing/sysfs-platform-asus-wmi". Is this a thermal
sensor? If it's the fact, how can I change the environment so that this
sensor gives me variable data?

Thanks,
baolu

