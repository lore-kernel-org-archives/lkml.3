Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaEIKrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:47:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbaEIKrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:47:02 -0400
Date: Fri, 9 May 2014 12:46:58 +0200
From: Borislav Petkov <bp@suse.de>
To: Andres Freund <andres@anarazel.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] x86: Fix typo preventing msr_set/clear_bit from
 having an effect
Message-ID: <20140509104658.GD16058@pd.tnic>
References: <1399598957-7011-1-git-send-email-andres@anarazel.de>
 <1399598957-7011-2-git-send-email-andres@anarazel.de>
 <20140509075452.GA16058@pd.tnic>
 <20140509103942.GA30231@awork2.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140509103942.GA30231@awork2.anarazel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 12:39:42PM +0200, Andres Freund wrote:
> It got caught before the release, so all is well...

Yeah.

> Actually rather surprised it only causes relatively minor problems;
> i.e. still boots.

Well, I did switch only a couple of sites in intel.c, maybe you got
lucky... (if that can be called getting lucky at all :-P).

> Did I CC the correct people for this to get picked up for 3.15 or to I
> need to do anything else?

Yes, you did, it looks good.

Thanks!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
