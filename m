Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbaIDVh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:37:59 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:37371 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbaIDVh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:37:57 -0400
Date: Thu, 4 Sep 2014 22:37:53 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Michael Brown <mbrown@fensystems.co.uk>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
Message-ID: <20140904213753.GM3001@console-pimps.org>
References: <5406D0DB.90401@canonical.com>
 <CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>
 <54073409.6030004@canonical.com>
 <CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>
 <20140903175948.GH3001@console-pimps.org>
 <CAKv+Gu9tejixb3Kb3YM_7sLcpKNuRHN+Dn+twFyCAXx99wYRCw@mail.gmail.com>
 <54084376.8090002@canonical.com>
 <540860F1.6060801@fensystems.co.uk>
 <CAKv+Gu8wALTqtNQK_855A7M5f2a+EB1JyLxo=j6G0T1cf8ZFog@mail.gmail.com>
 <CAKv+Gu_sLmkBHF-9GyPUgfAbLYirQTD4vk63o6HzdZhm6s_e0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_sLmkBHF-9GyPUgfAbLYirQTD4vk63o6HzdZhm6s_e0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep, at 11:25:48PM, Ard Biesheuvel wrote:
> 
> As it turns out, this breaks 32-bit, and the linker script is shared.
> 
> So I suggest that we go with Matt's suggestion, i.e., move/clone the
> GOT fixup code so that it runs exactly once in each code path, but
> early enough so that the embedded EFI application gets the treatment
> too.
> And don't forget head_32.S ...

Thanks Ard, I'll take a look in the morning.

-- 
Matt Fleming, Intel Open Source Technology Center
