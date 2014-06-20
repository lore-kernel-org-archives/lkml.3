Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718AbaFTEbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 00:31:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39286 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269AbaFTEbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 00:31:42 -0400
Message-ID: <53A3B8F9.1080005@zytor.com>
Date: Thu, 19 Jun 2014 21:30:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: linux-next: build warning after merge of the tip tree
References: <20140616115709.3fce3a2a@canb.auug.org.au> <20140620142436.385e1c10@canb.auug.org.au>
In-Reply-To: <20140620142436.385e1c10@canb.auug.org.au>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 09:24 PM, Stephen Rothwell wrote:
> Hi all,
> 
> On Mon, 16 Jun 2014 11:57:09 +1000 Stephen Rothwell 
> <sfr@canb.auug.org.au> wrote:
>> 
>> After merging the tip tree, today's linux-next build (x86_64 
>> allmodconfig) produced this warning:
>> 
>> In file included from 
>> arch/x86/crypto/camellia_aesni_avx_glue.c:23:0: 
>> arch/x86/include/asm/xsave.h:73:12: warning: 
>> 'xsave_state_booting' defined but not used [-Wunused-function] 
>> static int xsave_state_booting(struct xsave_struct *fx, u64 mask)
>> ^
>> 
>> Lots of these ...
>> 
>> Introduced by commit adb9d526e982 ("x86/xsaves: Add xsaves and 
>> xrstors support for booting time").  Forgotten "inline" :-(
> 
> Ping?
> 

I already applied an equivalent patch from Borislav.

	-hpa

