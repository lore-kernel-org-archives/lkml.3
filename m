Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab3F1O5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:57:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35345 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab3F1O5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:57:37 -0400
Date: Fri, 28 Jun 2013 16:57:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Wang YanQing <udknight@gmail.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        bp@suse.de, fenghua.yu@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2]x86: Fix override new_cpu_data.x86 with 486
Message-ID: <20130628145734.GB24494@pd.tnic>
References: <20130628144516.GA2177@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130628144516.GA2177@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 10:45:16PM +0800, Wang YanQing wrote:
> We should set X86 to 486 before use cpuid
> to detect the cpu type, if we set X86 to 486
> after cpuid, then we will get 486 until
> cpu_detect runs.
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>

Acked-by: Borislav Petkov <bp@suse.de>

Since this is not a critical bugfix but a mere correctness issue, and it
is too late for 3.11 anyway, it is most likely going to go straight to
3.12.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
