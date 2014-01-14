Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaANS6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:58:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42016 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbaANS6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:58:08 -0500
Date: Tue, 14 Jan 2014 19:58:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Aravind.Gopalakrishnan@amd.com, tglx@linutronix.de, bp@suse.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/microcode] x86, microcode: Move to a proper location
Message-ID: <20140114185802.GB29871@pd.tnic>
References: <tip-bad5fa631fca5466401cd4a48e30cc1f1cb6101e@git.kernel.org>
 <52D56174.9010608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D56174.9010608@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 08:10:28AM -0800, H. Peter Anvin wrote:
> Quite frankly I would be much happier if we didn't stash so much under
> arch/x86/kernel/cpu ... quite frankly it feels like almost *anything*
> could go under there. The microcode code, for example, could go under
> its own subtree.

Yeah, about the microcode, shouldn't it be under kernel/cpu/? My train
of thought is: because it is cpu-related functionality, it logically
belongs there.

Or do we rather apply the shallow tree logic of

arch/x86/microcode
arch/x86/events
...

?

I have to say, arch/x86/kernel/cpu/ is kinda long and hard to remember
so the shallow structure should be nicer on the eyes and the brain :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
