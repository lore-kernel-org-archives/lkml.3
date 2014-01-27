Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaA0RYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:24:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35467 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbaA0RYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:24:37 -0500
Date: Mon, 27 Jan 2014 18:24:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Michael Matz <matz@suse.de>, Michal Hocko <mhocko@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86: Disable traditional FPU instructions too
Message-ID: <20140127172428.GF6839@pd.tnic>
References: <20140127163758.GC6839@pd.tnic>
 <52E68C25.1070804@zytor.com>
 <alpine.LNX.2.00.1401271742300.14101@pobox.suse.cz>
 <87ha8pqryl.fsf@tassilo.jf.intel.com>
 <52E69464.4010705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52E69464.4010705@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 09:16:20AM -0800, H. Peter Anvin wrote:
> > checkpatch would seem to be the right place to check for this?

checkpatch is not mandatory.

> Ideally gcc should have a -no-float option...

Yeah.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
