Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaEERIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:08:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:18419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbaEERIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:08:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,989,1389772800"; 
   d="scan'208";a="506199944"
Message-ID: <5367C6A7.5020008@linux.intel.com>
Date: Mon, 05 May 2014 10:13:11 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: coretemp.0 folder contents changed
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

for kernel : 3.15.rc3 .

Is there any change in the coretemp? Previously we used to see, tempx 
data (like temp2_input, temp2_max etc.)
/sys/devices/platform/coretemp.0/.

Now We don't see them. Now we have to go 
/sys/devices/platform/coretemp.0/hwmon/hwmon?/ to get these values.

Thanks,
Srinivas

