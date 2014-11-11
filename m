Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaKKTyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:54:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53707 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbaKKTyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:54:44 -0500
Date: Tue, 11 Nov 2014 20:54:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        x86@kernel.org
Subject: Re: [PATCH 3/6] x86: Add support for the clwb instruction
Message-ID: <20141111195438.GO31490@pd.tnic>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
 <1415731396-19364-4-git-send-email-ross.zwisler@linux.intel.com>
 <20141111191239.GC31523@pd.tnic>
 <1415735332.21508.1.camel@theros.lm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1415735332.21508.1.camel@theros.lm.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 12:48:52PM -0700, Ross Zwisler wrote:
> Essentially we need one additional byte at the beginning of the clflush so
> that we can flip it into a clflushopt by changing that byte into a 0x66
> prefix.  Two options are to either insert a 1 byte ASM_NOP1, or to add a 1
> byte NOP_DS_PREFIX.  Both have no functional effect with the plain clflush,
> but I've been told that executing a clflush + prefix should be faster than
> executing a clflush + NOP.

I see. :)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
