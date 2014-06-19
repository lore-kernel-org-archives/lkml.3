Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaFSG2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 02:28:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41629 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbaFSG2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 02:28:31 -0400
Date: Thu, 19 Jun 2014 08:28:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
Message-ID: <20140619062824.GB22025@pd.tnic>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-8-git-send-email-qiaowei.ren@intel.com>
 <20140618100745.GB24419@pd.tnic>
 <9E0BE1322F2F2246BD820DA9FC397ADE016A3BAA@shsmsx102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE016A3BAA@shsmsx102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 01:13:48AM +0000, Ren, Qiaowei wrote:
> On 2014-06-18, Borislav Petkov wrote:
> > On Wed, Jun 18, 2014 at 05:44:13PM +0800, Qiaowei Ren wrote:
> > 
> > This whole insn decoding machinery above looks like adapted from
> > arch/x86/lib/insn.c. You should merge it with the generic code in
> > insn.c instead of homegrowing it here only for the purposes of MPX.
> > And if it doesn't work for your needs, you should should extend the
> > generic code to do so.

> Petkov, as we discussed on initial version of this patchset, general
> insn framework didn't work out well and I have tried to use generic
> struct insn, insn_field, etc. for obvious benefits.

Let me repeat myself: "And if it doesn't work for your needs, you should
extend the generic code to do so."

We don't do homegrown almost-copies of generic code.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
