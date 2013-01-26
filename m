Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab3AZPkL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 10:40:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47758 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab3AZPkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 10:40:09 -0500
Date: Sat, 26 Jan 2013 16:42:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, arjan@linux.intel.com,
        jbeulich@suse.com, ling.ml@alipay.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86/defconfig: Turn on
 CONFIG_CC_OPTIMIZE_FOR_SIZE= y in the 64-bit defconfig
Message-ID: <20130126154256.GB16044@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, mingo@kernel.org,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	arjan@linux.intel.com, jbeulich@suse.com, ling.ml@alipay.com,
	rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
	linux-tip-commits@vger.kernel.org
References: <1359123061-6139-1-git-send-email-ling.ma@alipay.com>
 <tip-d94ffd677469ef729e9d6e968191872577a6119e@git.kernel.org>
 <20130126125208.GC21395@pd.tnic>
 <8b0dfc4a-6f9c-498a-9844-4d99deb3052f@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8b0dfc4a-6f9c-498a-9844-4d99deb3052f@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 07:18:26AM -0800, H. Peter Anvin wrote:
> On the CPUs Ling is testing on the downsides of -Os probably matter
>less, in particular since rep movsb works well.
>
> It is questionable as a generic default, though.
>
> The whole -Ok discussion came from that.

Hmm,

maybe this warrants some sort of a text addition to the config option
about when and where it is ok to select -Os. Also, is it so that
on those CPUs, -Os is always better or at least neutral so that it
doesn't cause any perf regressions when people enable it? I mean, I
see only netperf and volano runs in the commit message, maybe running
a comprehensive set of benchmarks would give us a much more detailed
picture...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
