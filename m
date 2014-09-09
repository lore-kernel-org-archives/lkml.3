Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbaIIGsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:48:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35435 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322AbaIIGsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:48:11 -0400
Date: Tue, 9 Sep 2014 08:48:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86/microcode: add parameter dis_ucode_ldr in
 kernel-paramenters.txt
Message-ID: <20140909064803.GB28023@nazgul.tnic>
References: <1409857626-55464-1-git-send-email-fenghua.yu@intel.com>
 <20140905085709.GC11432@nazgul.tnic>
 <540DFED8.5080909@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <540DFED8.5080909@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 12:09:12PM -0700, H. Peter Anvin wrote:
> Are you genuinely saying we shouldn't document this command line
> parameter? Sorry, it really doesn't work that way.

My intent is to keep this one from getting abused for the wrong reasons.
Not documenting it is probably not going to get me that in the end,
though. Right.

-- 
Regards/Gruss,
    Boris.
--
