Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab3GXSIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:08:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48245 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab3GXSIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:08:10 -0400
Date: Wed, 24 Jul 2013 20:08:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix early microcode loading on AMD
Message-ID: <20130724180804.GL30777@pd.tnic>
References: <20130723135853.579c3cd5@googlemail.com>
 <20130723151552.GF8497@pd.tnic>
 <CAPVoSvR30mjRq8Kcp34akb6R1oTi4Y+z7CCO_8FWK5cGd-W61A@mail.gmail.com>
 <20130724141927.GI30777@pd.tnic>
 <CAPVoSvRfo7jePJ-NK444s9XwZK96xpf5w=vwQ9xRMp8oH-rVig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPVoSvRfo7jePJ-NK444s9XwZK96xpf5w=vwQ9xRMp8oH-rVig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 05:01:39PM +0200, Torsten Kaiser wrote:
> init_amd() will fill that field. (You could alway compile with
> CONFIG_MICROCODE_AMD=n and that field would still need filling)
> And as that will get called before smp_store_(boo)_cpu_info()
> everything should be fine.

Ah yes, I missed that. Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
