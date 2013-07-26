Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573Ab3GZTW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 15:22:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:52476 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab3GZTWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 15:22:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,752,1367996400"; 
   d="scan'208";a="377206541"
Message-ID: <51F2CE21.8030000@linux.intel.com>
Date: Fri, 26 Jul 2013 12:29:37 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: device_register and device_create_file rules
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am aware that it it is always recommended that attributes must be 
associate via attribute groups when calling device_register() .
This way when the device is created, user space can always see 
attributes once they get device create notification via uevent.

I have need to create/delete attributes on fly using 
device_create_file/device_remove_file. In past several drivers did that.

But with the enforcements of device model for new class of drivers, is 
it a big NO? I am not aware of change notification calls other than for 
kobject_uevent.


Thanks,
Srinivas





