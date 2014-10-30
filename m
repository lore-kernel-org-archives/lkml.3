Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161263AbaJ3VkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 17:40:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60996 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933386AbaJ3VkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 17:40:01 -0400
Date: Thu, 30 Oct 2014 22:39:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: Chen Yucong <slaoub@gmail.com>, Tony Luck <tony.luck@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
Message-ID: <20141030213954.GG11178@pd.tnic>
References: <20141009165339.GA11360@arav-dinar>
 <20141009173529.GC17647@pd.tnic>
 <5436DB72.1090507@amd.com>
 <20141021202840.GD4420@pd.tnic>
 <1413942678.17435.11.camel@debian>
 <20141022081618.GA2511@pd.tnic>
 <1413968014.7070.12.camel@debian>
 <20141022093042.GB2511@pd.tnic>
 <54510EFC.2080107@amd.com>
 <54528BB1.7080401@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54528BB1.7080401@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 02:04:17PM -0500, Aravind Gopalakrishnan wrote:
> Hi Boris,
> I have tested the branch with this bit:
> 
>  if (b.interrupt_capable) {
>             ... ...
>             if (mce_threshold_vector != amd_threshold_interrupt)
>                     mce_threshold_vector = amd_threshold_interrupt;
>     }
> 
> and it works fine.

Good, I'll adjust Chen's patch tomorrow then and send up.

Thanks a lot for testing!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
