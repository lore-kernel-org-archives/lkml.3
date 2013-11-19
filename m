Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab3KSSXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:23:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36535 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab3KSSXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:23:12 -0500
Date: Tue, 19 Nov 2013 19:23:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Johannes =?utf-8?B?TMO2dGhiZXJn?= <johannes@kyriasis.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: boot: Fix mixed indentation in a20.c
Message-ID: <20131119182306.GD3515@pd.tnic>
References: <1384797009-4096-1-git-send-email-johannes@kyriasis.com>
 <528ACB6A.1040809@zytor.com>
 <20131119072241.GB32478@gmail.com>
 <20131119103408.GA3640@pd.tnic>
 <1384883323.17783.35.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1384883323.17783.35.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 09:48:43AM -0800, Joe Perches wrote:
> git diff -w and git blame -w both ignore whitespace changes and can
> help in tracking down actual modifications.

That's not the point - I don't want those commits there getting in the
way.

If it

 * doesn't fix a real bug,
 * doesn't improve code generation
 * doesn't have any other positive effect on the resulting object code

then it doesn't need to be there.

Whitespace jerking off doesn't belong in the kernel.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
