Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab3HTRkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:40:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:36591 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab3HTRk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:40:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,921,1367996400"; 
   d="scan'208";a="365698986"
Message-ID: <5213ABB9.5060600@linux.intel.com>
Date: Tue, 20 Aug 2013 10:47:37 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: kobject_uevent call in device_add
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any specific reason that "kobject_uevent(&dev->kobj, KOBJ_ADD)
is called before calling  "class_intf->add_dev(dev, class_intf) in the 
function device_add()?

I am wondering if we call after class_intf->add_dev, it will provide 
opportunity for
client drivers to do some operation before user space is notified.

Thanks,
Srinivas





