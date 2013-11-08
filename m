Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab3KHOin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 09:38:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54321 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab3KHOil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 09:38:41 -0500
Date: Fri, 8 Nov 2013 15:40:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@suse.de>,
        mingo@kernel.org, mingo@redhat.com, jacob.w.shin@gmail.com,
        oleg@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        hpa@zytor.com, linux-kernel@vger.kernel.org, sherry.hurwitz@amd.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
 HW_BREAKPOINT_LEN_8
Message-ID: <20131108144050.GA7044@x1.alien8.de>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com>
 <20131031095829.GE2253@localhost.localdomain>
 <20131031104836.GC10544@pd.tnic>
 <527D5630.3000906@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <527D5630.3000906@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 06:22:56AM +0900, Suravee Suthikulpanit wrote:
> Sorry for late reply. And yes, the BDKG called it "Breakpoint
> Extension". Keeping the name consistent with the documentation might
> be best for now to avoid confusion.
>
> So, would you like me to send in a new patch to add this comment?

No need, the X86_FEATURE_BPEXT define has a comment already.

-- 
Regards/Gruss,
Boris.
