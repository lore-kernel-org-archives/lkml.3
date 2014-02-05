Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaBEQkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:40:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbaBEQkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:40:31 -0500
Date: Wed, 5 Feb 2014 11:40:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, apic: clean up handling of boot_cpu_physical_apicid
 in boot process
Message-ID: <20140205164025.GG6042@redhat.com>
References: <52D7A8F0.70807@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D7A8F0.70807@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 06:40:00PM +0900, HATAYAMA Daisuke wrote:

[..]
> diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
> index 3142a94..724853f 100644
> --- a/arch/x86/include/asm/mpspec.h
> +++ b/arch/x86/include/asm/mpspec.h
> @@ -47,6 +47,7 @@ extern int mp_bus_id_to_type[MAX_MP_BUSSES];
>  extern DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
>  
>  extern unsigned int boot_cpu_physical_apicid;
> +extern unsigned int bios_bsp_physical_apicid;

I think put some comments here to explain clearly what is
boot_cpu_physical_apicid and what is bios_bsp_physical_apicid and what's
the difference. So that anybody making use of these variables or changing
code understands the difference better.

Thanks
Vivek
