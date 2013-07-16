Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248Ab3GPQ2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:28:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:16810 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932546Ab3GPQ2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:28:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,678,1367996400"; 
   d="scan'208";a="371248126"
Message-ID: <51E57631.2030805@linux.intel.com>
Date: Tue, 16 Jul 2013 09:34:57 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org
CC: "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: driver model, duplicate names question
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I would like to create tree like structure using device model (struct 
device, device_register/device_unregister) using parent/child 
relationship while creation. I want to be able to create duplicate 
names, when their parents are different, similar to a directory structure.
I see that I can't create devices with duplicate names (device names), 
even when their parents are different.

How can I allow duplicate names when their parents are different devices?
I want to avoid flat model as I have parent child relationship and there 
will be too many devices using flat model.

Why, I need?
I am going to publish RFC for a new power cap class driver. We have a 
multiple controllers under power cap class (they are devices). Under 
which there are multiple power zones, with parent/child relationships. 
Currently I have to use  kobject_init_and_add, which I want to avoid and 
just use device_register. Other places, wherever such relationships are 
required, kobjects are used like cpufreq.

Thanks,
Srinivas Pandruvada
Open Source Technology Center,
Intel Corp.






