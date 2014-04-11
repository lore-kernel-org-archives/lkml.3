Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaDKSlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:41:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:13934 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbaDKSlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:41:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,843,1389772800"; 
   d="scan'208";a="417922557"
Message-ID: <53483743.9060500@linux.intel.com>
Date: Fri, 11 Apr 2014 11:41:07 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Olaf Hering (olaf@aepfle.de)" <olaf@aepfle.de>
Subject: Re: [GIT PULL] x86/hyperv fix for v3.15-rc1
References: <201404111739.s3BHdRiW025864@terminus.zytor.com> <d2879039ca5e4164aedebe1c2cb0a596@BY2PR03MB299.namprd03.prod.outlook.com>
In-Reply-To: <d2879039ca5e4164aedebe1c2cb0a596@BY2PR03MB299.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 11:39 AM, KY Srinivasan wrote:
> 
> Peter,
> 
> It may be better not to include the patch titled:
> 
> x86, hyperv: When on Hyper-v use NULL legacy PIC (2014-04-03 22:00:13 -
> 0700)
> 
> Without this patch, kexec will not work on Hyper-V efi firmware and that is the way it has been.
> While I tested this patch on both legacy and EFI firmware on Hyper-V, Olaf is reporting that on the
> configurations he is building, this patch causes problems on Hyper-V legacy firmware.
> 
> I am currently working on the idea you have had - using NULL legacy PIC only when
> PIC is not there.
> 

OK, Linus, please drop this pull request (the above patch is the only
patch in the pull anyway.)

	-hpa


