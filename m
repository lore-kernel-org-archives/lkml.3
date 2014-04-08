Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaDHC5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 22:57:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:31886 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbaDHC5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 22:57:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,815,1389772800"; 
   d="scan'208";a="516603127"
Date: Tue, 8 Apr 2014 10:53:29 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
Cc: *S-Par-Maintainer <SParMaintainer@unisys.com>, Ken Cox <jkc@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Jet Chen <jet.chen@intel.com>
Subject: Re: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
Message-ID: <20140408025329.GB16434@localhost>
References: <20140407111725.GC25152@localhost>
 <C97001BC43954D438ACB059713BA5CDF92040F0F00@USEA-EXCH7.na.uis.unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C97001BC43954D438ACB059713BA5CDF92040F0F00@USEA-EXCH7.na.uis.unisys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> Fengguang,
> 
> I ran your script against freshly-checked-out source from staging-next, and was not able to reproduce the error with it. My boot log is attached. I noticed that your log did not have "Hypervisor detected: KVM" in the trace. The KVM options in your script also differ substantially from the ones shown at the end of your trace...
 
> When I reran your script with the "-cpu Haswell,+smep,+smap" option I was able to get the same result as you. IMHO KVM should not be setting this bit if it's emulating bare metal.

Sorry.. We tried to provide a simplified reproduce script and in your
case, it has a significant mismatch with the real KVM options. We'll
fix it, thanks for pointing it out!

Thanks,
Fengguang
