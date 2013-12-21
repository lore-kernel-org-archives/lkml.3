Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3LURfX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 12:35:23 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:40932 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867Ab3LURfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 12:35:21 -0500
Date: Sat, 21 Dec 2013 17:35:15 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        akpm@linux-foundation.org, mingo@kernel.org, msalter@redhat.com,
        leif.lindholm@linaro.org
Subject: Re: [PATCH v7 00/12] kexec kernel efi runtime support
Message-ID: <20131221173515.GE29501@console-pimps.org>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec, at 06:02:10PM, Dave Young wrote:
> Here is the V7 patchset for supporting kexec kernel efi runtime.
> Per pervious discussion I pass the 1st kernel efi runtime mapping
> via setup_data to 2nd kernel. Besides of the runtime mapping
> info I also pass the fw_vendor, runtime, config table, smbios
> physical address in setup_data. EFI spec mentioned fw_vendor,
> runtime, config table addresses will be converted to virt address
> after entering virtual mode, but we will use it as physical address
> in efi_init. For smbios EFI spec did not mention about the address
> updating, but during my test on a HP workstation, the bios will
> convert it to Virt addr, thus pass it in setup_data as well.

OK Dave, I've pulled patches 3-12 into the 'kexec' branch at,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git

I plan on sending this branch to the tip folks this week for further
testing.

Please have a look and make sure I haven't messed anything up when
dropping the first two patches (though they were very small and trival).

Toshi, if you could grab that branch and give it a test, that'd be
excellent.

-- 
Matt Fleming, Intel Open Source Technology Center
