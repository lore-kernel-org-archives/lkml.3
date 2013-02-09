Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882Ab3BIXN4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 18:13:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56907 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349Ab3BIXNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 18:13:55 -0500
Date: Sun, 10 Feb 2013 00:13:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 5/5] x86, head_32: Remove an old gcc2 fix
Message-ID: <20130209231351.GB5556@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
References: <1360439574-16122-1-git-send-email-bp@alien8.de>
 <1360439574-16122-6-git-send-email-bp@alien8.de>
 <af2ed3e1-3ac4-421c-b1a8-bfa243327ffb@email.android.com>
 <20130209212342.GA5556@pd.tnic>
 <5116CC68.3090804@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5116CC68.3090804@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2013 at 02:23:36PM -0800, H. Peter Anvin wrote:
> The pushfl/popfl sequence clears DF too...

Yes, indeed, good realization!

Ok, I'll fold that fact as a comment into the 2/5 patch resend it only
as a reply to this mail so as not to spam unnecessarily.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
