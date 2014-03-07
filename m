Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaCGFEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 00:04:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:30032 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbaCGFD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 00:03:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,605,1389772800"; 
   d="scan'208";a="487702919"
Message-ID: <53195336.9080606@linux.intel.com>
Date: Thu, 06 Mar 2014 21:03:50 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <borislav.petkov@amd.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [qemu64,+smep,+smap] WARNING: CPU: 1 PID: 0 at arch/x86/kernel/cpu/amd.c:220
 init_amd()
References: <20140307015833.GA10048@localhost>
In-Reply-To: <20140307015833.GA10048@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 05:58 PM, Fengguang Wu wrote:
> Hi all,
> 
> I find the below WARNING shows up only in
> 
>         qemu-system-x86_64 -cpu qemu64,+smep,+smap
> 

Yes, it is because Qemu doesn't show the AMD-specific SMP CPUID bit.
It's harmless in that sense.

Unfortunately these things are hard to fix in Qemu.

	-hpa

