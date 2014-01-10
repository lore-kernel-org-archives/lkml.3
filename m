Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbaAJTGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 14:06:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbaAJTFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 14:05:31 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>,
        kosaki.motohiro@gmail.com, dyoung@redhat.com,
        linux-acpi@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/2] Add option to disable ACPI Memory Hotplug [v2]
Date: Fri, 10 Jan 2014 14:04:55 -0500
Message-Id: <1389380698-19361-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds the ability for the user to disable ACPI Memory Hotplug
by adding "acpi_no_memhotplug" as a kernel paramaeter, and disables
ACPI Memory Hotplug by default when the memmap=exactmap and mem=X parameters
are used.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linn Crosetto <linn@hp.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: kosaki.motohiro@gmail.com
Cc: dyoung@redhat.com
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: linux-acpi@vger.kernel.org
Cc: linux-mm@kvack.org


Prarit Bhargava (2):
  acpi memory hotplug, add parameter to disable memory hotplug [v2]
  x86, e820 disable ACPI Memory Hotplug if memory mapping is specified
    by     user [v2]

 Documentation/kernel-parameters.txt |    3 +++
 arch/x86/kernel/e820.c              |   10 +++++++++-
 drivers/acpi/acpi_memhotplug.c      |   17 +++++++++++++++++
 include/linux/memory_hotplug.h      |    3 +++
 4 files changed, 32 insertions(+), 1 deletion(-)

-- 
1.7.9.3

