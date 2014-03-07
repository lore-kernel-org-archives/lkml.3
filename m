Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaCGWeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 17:34:23 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41586 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbaCGWeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 17:34:22 -0500
Date: Fri, 7 Mar 2014 23:34:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [qemu64,+smep,+smap] WARNING: CPU: 1 PID: 0 at
 arch/x86/kernel/cpu/amd.c:220 init_amd()
Message-ID: <20140307223407.GH5255@pd.tnic>
References: <20140307015833.GA10048@localhost>
 <53195336.9080606@linux.intel.com>
 <20140307055035.GA5230@localhost>
 <531A164B.8040402@linux.intel.com>
 <20140307191050.GA10961@redhat.com>
 <531A33A2.5030706@linux.intel.com>
 <20140307213856.GF5255@pd.tnic>
 <20140307220655.GA580@redhat.com>
 <531A4426.30504@linux.intel.com>
 <20140307222750.GA10867@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140307222750.GA10867@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 06:27:50AM +0800, Fengguang Wu wrote:
> Yeah I confirmed that it works w/o the warning!
> 
> [    0.575854] smpboot: CPU0: Intel Core Processor (Haswell) (fam: 06, model: 3c, stepping: 01)

Hahah, Haswell is just a couple models away from K7: model 6 vs
model 3c, same family 6 though. So shouldn't be a big difference
performance-wise.

Wohahahahha... :-))))))

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
