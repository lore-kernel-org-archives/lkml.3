Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbaCBWpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 17:45:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:18879 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbaCBWpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 17:45:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,574,1389772800"; 
   d="scan'208";a="492532453"
Message-ID: <5313B47B.6020402@linux.intel.com>
Date: Mon, 03 Mar 2014 06:45:15 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
References: <ec95d575-070f-4c62-8b27-3ce281cb192e@email.android.com> <53127AA7.8040700@linux.intel.com> <53127C4B.1060505@zytor.com> <53128DA0.9060105@linux.intel.com> <53129256.6060704@zytor.com> <20140302022334.GA1131@srcf.ucam.org> <c4f4929e-6bab-45b9-ac6b-cbdea5fd57e8@email.android.com> <53130A46.1010801@linux.intel.com> <cfbdc582-9fc0-4335-9974-d508c2da1c71@email.android.com> <5313AD1B.6050403@linux.intel.com> <20140302222654.GA17838@srcf.ucam.org>
In-Reply-To: <20140302222654.GA17838@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/3 6:26, Matthew Garrett wrote:
> On Mon, Mar 03, 2014 at 06:13:47AM +0800, Li, Aubrey wrote:
> 
>> If you have a system can't be rebooted by all of the known methods, we
>> have to figure out how to make reboot work and add the new methods.
> 
> The only methods used by Windows are the keyboard controller, the ACPI 
> registers and (according to your results) the EFI reboot mechanism. If 
> none of those work under Linux but Windows is able to reboot 
> successfully then we don't need to add new methods, we need to find out 
> why the existing methods don't work.
> 

One example in my hand is, 32bit windows calls 32bit EFI firware, so
reboot works. However, I installed 64bit linux on this 32bit EFI
machine, so none of ACPI/KBD/EFI works.

Other cases even if we figured out why ACPI/KBD/EFI don't work, we still
have to make our change in the linux kernel, because we can't change
firmware.

So, if you are still suggesting we add EFI only, please let me know your
plan about adding dmidecode table and if it's acceptable to add new
tables, I have three waiting: ASUS-T100, Dell Venue 8 Pro, and Dell
Venue 11 Pro.

Or if you don't want to keep adding the dmidecode, please let me know
your plan so that I don't want to keep driving this patch.

Thanks,
-Aubrey
