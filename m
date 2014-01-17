Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaAQRE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:04:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52859 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbaAQRET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:04:19 -0500
Date: Fri, 17 Jan 2014 18:04:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ren Qiaowei <qiaowei.ren@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
 bound tables
Message-ID: <20140117170410.GH8715@pd.tnic>
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com>
 <1389518403-7715-2-git-send-email-qiaowei.ren@intel.com>
 <20140112092019.GA3664@pd.tnic>
 <52D35ABB.8070904@intel.com>
 <20140113103808.GC5388@pd.tnic>
 <52D95AD4.6060603@zytor.com>
 <20140117164855.GF8715@pd.tnic>
 <52D95F93.3030000@zytor.com>
 <20140117165656.GA9024@pd.tnic>
 <52D96149.8070706@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D96149.8070706@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 08:58:49AM -0800, H. Peter Anvin wrote:
> #BR exception from kernel space -> panic.
> 
> We have tons of rules on kernel code... e.g. no FPU usage.  This one is
> minor in comparison.

So basically review should catch those wrong BOUND usages?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
