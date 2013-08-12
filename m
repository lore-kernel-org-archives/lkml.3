Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab3HLN5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:57:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50844 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043Ab3HLN5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:57:06 -0400
Date: Mon, 12 Aug 2013 15:57:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86, AMD: simplify load_microcode_amd() to fix early
 microcode loading to no longer access uninitialized per-cpu data
Message-ID: <20130812135702.GG18018@pd.tnic>
References: <20130723230610.73bd048d@googlemail.com>
 <20130724193250.GO30777@pd.tnic>
 <20130808192943.GF27974@pd.tnic>
 <20130812153719.2b357d5d@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130812153719.2b357d5d@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 03:37:19PM +0200, Johannes Hirte wrote:
> Just tested your amd-ucode branch with CONFIG_MICROCODE_AMD_EARLY
> re-enabled and it works so far.

Ok, that's good news. Thanks a lot!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
