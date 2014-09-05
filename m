Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbaIEI5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:57:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37447 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbaIEI5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:57:18 -0400
Date: Fri, 5 Sep 2014 10:57:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86/microcode: add parameter dis_ucode_ldr in
 kernel-paramenters.txt
Message-ID: <20140905085709.GC11432@nazgul.tnic>
References: <1409857626-55464-1-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1409857626-55464-1-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 12:07:06PM -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> The kernel parameter dis_ucode_ldr disables early loading microcode from
> initrd. The parameter was introduced earlier by Borislave Petkov.

My name is Borislav Petkov, without an "e".

> This patch adds the explanation for this parameter in
> Documentation/kernel-parameters.txt for user convenience.

As I said earlier, I don't want to do exactly that because this
parameter should be used only to rule out microcode loading causes a
problem and not regularly. I know, it doesn't stop people from looking
at the code but still.

So NAK.

-- 
Regards/Gruss,
    Boris.
--
