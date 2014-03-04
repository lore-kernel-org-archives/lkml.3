Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbaCDKov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:44:51 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39586 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087AbaCDKou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:44:50 -0500
Date: Tue, 4 Mar 2014 11:44:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Chris Bainbridge <chris.bainbridge@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andreas Mohr <andi@lisas.de>,
        Dennis Mungai <dmngaie@gmail.com>, x86@kernel.org,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        devzero@web.de
Subject: Re: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140304104447.GA4891@pd.tnic>
References: <20140228140043.GA12157@debian.local>
 <20140302205619.GA8676@rhlx01.hs-esslingen.de>
 <20140303080432.GA25489@localhost>
 <20140303192939.GD31265@pd.tnic>
 <20140304050122.GA3740@localhost>
 <5e866e2a-ea92-43f8-ae67-23f6052c91c8@email.android.com>
 <20140304060559.GA547@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140304060559.GA547@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 01:06:03PM +0700, Chris Bainbridge wrote:
> On Mon, Mar 03, 2014 at 09:04:19PM -0800, H. Peter Anvin wrote:
> > forcepae is descriptive.
> 
> Back to forcepae.

Ok, it looks ok to me after a quick look. Now you only have to ask
Dave whether he's fine with you merging his patch into yours, write a
nice commit message explaining why this patch is needed and give it a
final test on your machine.

Look at Documentation/SubmittingPatches for how to properly prepare the
patch. Oh, and use git if you don't do so already. :-)

And feel free to ask questions at any point if something's not clear.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
