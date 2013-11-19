Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab3KSKeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:34:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55991 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3KSKeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:34:12 -0500
Date: Tue, 19 Nov 2013 11:34:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Johannes =?utf-8?B?TMO2dGhiZXJn?= <johannes@kyriasis.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: boot: Fix mixed indentation in a20.c
Message-ID: <20131119103408.GA3640@pd.tnic>
References: <1384797009-4096-1-git-send-email-johannes@kyriasis.com>
 <528ACB6A.1040809@zytor.com>
 <20131119072241.GB32478@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131119072241.GB32478@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 08:22:41AM +0100, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > On 11/18/2013 09:50 AM, Johannes Löthberg wrote:
> > > Replace all mixed indentation with tabs
> > > 
> > > Signed-off-by: Johannes Löthberg <johannes@kyriasis.com>
> > 
> > NAK.  Not worth the churn in the absence of other changes.
> 
> Yes.
> 
> If a20.c was cleaned up altogether, that might be a more tempting 
> change, it has a good number of inconsistencies and improving it all 
> would make it more readable.
>  
> But it makes little sense to do an incomplete cleanup.

Yeah, senseless cleanup without any benefit whatsoever (yeah, fuck
readability! :-)) should be forbidden, if you ask me. Especially
since it dilutes and muds up git history and finding the patch which
introduced a change turns into a serious undertaking.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
