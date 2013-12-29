Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab3L2NF4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 08:05:56 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:38962 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968Ab3L2NFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 08:05:54 -0500
Date: Sun, 29 Dec 2013 13:05:46 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        akpm@linux-foundation.org, mingo@kernel.org, msalter@redhat.com,
        leif.lindholm@linaro.org
Subject: Re: [PATCH v7 09/12] efi: passing kexec necessary efi data via
 setup_data
Message-ID: <20131229130546.GA2618@console-pimps.org>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
 <1387533742-18018-10-git-send-email-dyoung@redhat.com>
 <20131221160416.GD29501@console-pimps.org>
 <20131223020958.GB3760@dhcp-16-126.nay.redhat.com>
 <20131223080741.GB28919@console-pimps.org>
 <20131225031259.GB6333@dhcp-16-126.nay.redhat.com>
 <20131225033205.GC6333@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131225033205.GC6333@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Dec, at 11:32:05AM, Dave Young wrote:
> 
> Matt, if you want to remove the map[0] please fold below one line
> patch? I have no strong opinion.
> 
> Index: linux/arch/x86/include/asm/efi.h
> ===================================================================
> --- linux.orig/arch/x86/include/asm/efi.h
> +++ linux/arch/x86/include/asm/efi.h
> @@ -139,7 +139,6 @@ struct efi_setup_data {
>  	u64 tables;
>  	u64 smbios;
>  	u64 reserved[8];
> -	efi_memory_desc_t map[0];
>  };
>  
>  extern u64 efi_setup;

Thanks Dave, I will fold this in. I would suggest updating your
kexec-tools patches so that the two structures are in sync.

-- 
Matt Fleming, Intel Open Source Technology Center
