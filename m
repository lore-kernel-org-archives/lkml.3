Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaCJAB5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 20:01:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:8898 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbaCJAB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 20:01:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,620,1389772800"; 
   d="scan'208";a="469301875"
Message-ID: <531D00DD.1060706@linux.intel.com>
Date: Sun, 09 Mar 2014 17:01:33 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>
CC: Dave Jones <davej@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [qemu64,+smep,+smap] WARNING: CPU: 1 PID: 0 at arch/x86/kernel/cpu/amd.c:220
 init_amd()
References: <20140307015833.GA10048@localhost> <53195336.9080606@linux.intel.com> <20140307055035.GA5230@localhost> <531A164B.8040402@linux.intel.com> <20140307191050.GA10961@redhat.com> <531A33A2.5030706@linux.intel.com> <20140307213856.GF5255@pd.tnic> <531CADC6.6020606@redhat.com>
In-Reply-To: <531CADC6.6020606@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2014 11:07 AM, Paolo Bonzini wrote:
> 
> We really should give a loud warning if qemu64 is used with KVM.  It
> makes no sense with KVM, even less than it does with dynamic translation.
> 

Well, this is dynamic translation.

	-hpa


