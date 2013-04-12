Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3DLJrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 05:47:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40864 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab3DLJra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 05:47:30 -0400
Date: Fri, 12 Apr 2013 11:47:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86, FPU: Fix FPU initialization
Message-ID: <20130412094724.GA2368@pd.tnic>
References: <20130410122527.GB8686@gmail.com>
 <20130410133251.GC6857@pd.tnic>
 <516586CF.90909@zytor.com>
 <20130410161122.GI6857@pd.tnic>
 <20130410212950.GA6899@pd.tnic>
 <20130411120952.GA18879@gmail.com>
 <51670E51.6020106@zytor.com>
 <20130411202328.GA15955@pd.tnic>
 <20130412053234.GB3887@gmail.com>
 <f3a4fce2-090e-4a08-b05c-0281a95e8943@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f3a4fce2-090e-4a08-b05c-0281a95e8943@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 10:34:48PM -0700, H. Peter Anvin wrote:
> >The lockup went away after excluding x86/cpu. I'll try more testing
> >as time permits.

Right,

so tip:x86/cpu has all in all 11 patches. Maybe a quick bisect?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
