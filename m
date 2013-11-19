Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab3KSS7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:59:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44469 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab3KSS7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:59:11 -0500
Date: Tue, 19 Nov 2013 19:59:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>, Ingo Molnar <mingo@kernel.org>,
        Johannes =?utf-8?B?TMO2dGhiZXJn?= <johannes@kyriasis.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: boot: Fix mixed indentation in a20.c
Message-ID: <20131119185906.GA9774@pd.tnic>
References: <1384797009-4096-1-git-send-email-johannes@kyriasis.com>
 <528ACB6A.1040809@zytor.com>
 <20131119072241.GB32478@gmail.com>
 <20131119103408.GA3640@pd.tnic>
 <1384883323.17783.35.camel@joe-AO722>
 <20131119182306.GD3515@pd.tnic>
 <528BACCB.1090604@zytor.com>
 <1384885733.17783.37.camel@joe-AO722>
 <528BB1AC.7060708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <528BB1AC.7060708@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 10:45:00AM -0800, H. Peter Anvin wrote:
> I don't know (or even if it needs one,...

Exactly.

With the amount of real bugs/issues *actually* being reported out there,
why would people waste energy on senseless cleanups is beyond me.

a20.c is fine the way it is, it doesn't bother anyone, it works. So why
even touch it?

If people want to fix real issues, they can do lots of other sensible
work. One example would be: do randconfig builds and stare at the
warnings - there are a gazillion of them and I'm sure there are real
bugs hiding in there.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
