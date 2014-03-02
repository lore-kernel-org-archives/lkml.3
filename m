Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbaCBXXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:23:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:35863 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbaCBXXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:23:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,574,1389772800"; 
   d="scan'208";a="492540574"
Message-ID: <5313BD5A.1040409@linux.intel.com>
Date: Mon, 03 Mar 2014 07:23:06 +0800
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
References: <53127C4B.1060505@zytor.com> <53128DA0.9060105@linux.intel.com> <53129256.6060704@zytor.com> <20140302022334.GA1131@srcf.ucam.org> <c4f4929e-6bab-45b9-ac6b-cbdea5fd57e8@email.android.com> <53130A46.1010801@linux.intel.com> <cfbdc582-9fc0-4335-9974-d508c2da1c71@email.android.com> <5313AD1B.6050403@linux.intel.com> <20140302222654.GA17838@srcf.ucam.org> <5313B47B.6020402@linux.intel.com> <20140302231154.GA20891@srcf.ucam.org>
In-Reply-To: <20140302231154.GA20891@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/3 7:11, Matthew Garrett wrote:

>> So, if you are still suggesting we add EFI only, please let me know your
>> plan about adding dmidecode table and if it's acceptable to add new
>> tables, I have three waiting: ASUS-T100, Dell Venue 8 Pro, and Dell
>> Venue 11 Pro.
> 
> I don't think it's acceptable to add DMI entries to the reboot table. I 
> think you should add the EFI call (since we expect that to work now), 
> and I have no objection to adding cf9 to the end of the list if we have 
> standard PCI io ports (Windows doesn't do it, but we can hardly make 
> things worse).
> 
Windows doesn't do because there is no 32/64 mixed windows and EFI on
the planet. Since the silicon is actually 64 bit, I failed to see a
reason to refuse the user install 64bit linux on it. So we encountered a
case windows didn't.

So, you didn't mention BOOT_BIOS, if you don't want to add BOOT_BIOS,
and you also don't like DMI entires, how do you want to deal with the
machines requiring BOOT_BIOS to reboot their machine?

Thanks,
-Aubrey
