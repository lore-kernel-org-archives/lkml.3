Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab3LFSzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:55:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43561 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab3LFSzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:55:39 -0500
Date: Fri, 6 Dec 2013 19:55:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Xudong Hao <xudong.hao@intel.com>,
        Liu Jinsong <jinsong.liu@intel.com>
Subject: Re: [PATCH 3/3] X86, mpx: Intel MPX xstate feature definition
Message-ID: <20131206185534.GA7528@pd.tnic>
References: <1386355976-11732-1-git-send-email-qiaowei.ren@intel.com>
 <1386355976-11732-3-git-send-email-qiaowei.ren@intel.com>
 <20131206134631.GD6694@pd.tnic>
 <52A2080A.9010208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52A2080A.9010208@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 09:23:22AM -0800, H. Peter Anvin wrote:
> On 12/06/2013 05:46 AM, Borislav Petkov wrote:
> > I'm guessing this and the struct lwp_struct above is being added so that
> > you can have the LWP XSAVE area size? If so, you don't need it: LWP
> > XSAVE area is 128 bytes at offset 832 according to my manuals so I'd
> > guess having a u8 lwp_area[128] should be fine.
> > 
> Sure, but any reason to *not* document the internal structure?

Only that you might start getting remove-this-unused-struct patches. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
