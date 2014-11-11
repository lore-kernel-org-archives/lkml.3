Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaKKTTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:19:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57824 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbaKKTTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:19:09 -0500
Date: Tue, 11 Nov 2014 20:19:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        x86@kernel.org
Subject: Re: [PATCH 3/6] x86: Add support for the clwb instruction
Message-ID: <20141111191904.GA12555@pd.tnic>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
 <1415731396-19364-4-git-send-email-ross.zwisler@linux.intel.com>
 <20141111191239.GC31523@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141111191239.GC31523@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 08:12:39PM +0100, Borislav Petkov wrote:
> > +			 ".byte 0x66; xsaveopt %P0",
> 
> Huh, XSAVEOPT?!? Shouldn't that be CLWB??

Bah, the same opcodes, only 0x66 prefix makes it into CLWB. Could use a
comment I guess.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
