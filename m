Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3JaKsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:48:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab3JaKst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:48:49 -0400
Date: Thu, 31 Oct 2013 11:48:36 +0100
From: Borislav Petkov <bp@suse.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: suravee.suthikulpanit@amd.com, mingo@kernel.org, mingo@redhat.com,
        jacob.w.shin@gmail.com, oleg@redhat.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sherry.hurwitz@amd.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
 HW_BREAKPOINT_LEN_8
Message-ID: <20131031104836.GC10544@pd.tnic>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com>
 <20131031095829.GE2253@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131031095829.GE2253@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix tglx's address.

On Thu, Oct 31, 2013 at 10:58:31AM +0100, Frederic Weisbecker wrote:
> Is this perhaps a bit too generic? Extension can mean about everything
> and who knows what other feature Intel and Amd will add to breakpoints
> in the future.

Yeah, but that's the name of the feature. When they come up with another
extension, they'll call it BP_EXT2, most probably...

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
