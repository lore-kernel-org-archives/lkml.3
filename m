Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaCBA0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 19:26:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:32304 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbaCBA0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 19:26:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,569,1389772800"; 
   d="scan'208";a="492258344"
Message-ID: <53127AA7.8040700@linux.intel.com>
Date: Sun, 02 Mar 2014 08:26:15 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg59@srcf.ucam.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
References: <53102AB9.40600@linux.intel.com> <20140228062325.GA3246@srcf.ucam.org> <53102F3C.4020806@linux.intel.com> <20140228064413.GA4900@srcf.ucam.org> <531032A0.8090903@linux.intel.com> <5310CBB7.4030407@linux.intel.com> <53110977.8080907@linux.intel.com> <53121496.8060603@linux.intel.com> <20140301172256.GA29417@srcf.ucam.org> <53123DCF.7040500@zytor.com> <20140301202139.GA9759@srcf.ucam.org> <ec95d575-070f-4c62-8b27-3ce281cb192e@email.android.com>
In-Reply-To: <ec95d575-070f-4c62-8b27-3ce281cb192e@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On March 1, 2014 12:21:39 PM PST, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> if we've hit the keyboard controller and ACPI twice, and the system is still alive, and 
>> if we have standard PCI ports, 

>> it doesn't seem like poking them is likely to make anything actively
worse.
> 
This is exactly what I'm trying to express. thanks Matt. It doesn't make
anything worse, it makes reboot working on some systems.

On 2014/3/2 4:26, H. Peter Anvin wrote:
> True... trying cf9_cond with low priority probably makes sense.

I'm not asking CF9 only, I'm asking all of the known method in reboot.c.
So, BIOS is appliable as well with the same logic and with low priority,
isn't it?

Thanks,
-Aubrey

