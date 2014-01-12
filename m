Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaALRHT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 12:07:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44426 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaALRHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 12:07:17 -0500
Message-ID: <52D2CBAC.5020901@zytor.com>
Date: Sun, 12 Jan 2014 09:06:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Qiaowei Ren <qiaowei.ren@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86, mpx: extend siginfo structure to include bound
 violation information
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com> <1389518403-7715-5-git-send-email-qiaowei.ren@intel.com> <20140112093013.GB3664@pd.tnic> <52D2C791.2030802@zytor.com> <20140112170354.GC3655@pd.tnic>
In-Reply-To: <20140112170354.GC3655@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2014 09:03 AM, Borislav Petkov wrote:
> On Sun, Jan 12, 2014 at 08:49:21AM -0800, H. Peter Anvin wrote:
>> I saw a previous version of the code that did that, and it really
>> didn't work out well -- it ended up being more complex and slower.
> 
> I suspected as much.
> 
> But, we still probably should use the generic struct insn, insn_field,
> etc and act on them in mpx.c instead of defining our own mpx_insn,
> mpx_insn_field, X86_MODRM_MOD, etc in the header which are more or less
> copied from insn.h, right?
> 

That may be.

	-hpa

