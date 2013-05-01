Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab3EAXDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 19:03:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36494 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335Ab3EAXC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 19:02:58 -0400
Date: Thu, 2 May 2013 01:02:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        Borislav Petkov <bp@suse.de>, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for
 building working KVM guest kernels
Message-ID: <20130501230254.GC15623@pd.tnic>
References: <tip-83aee67833071c7b73a83f7803388f7a9e481908@git.kernel.org>
 <alpine.DEB.2.02.1305011248220.8448@chino.kir.corp.google.com>
 <20130501203500.GC4466@pd.tnic>
 <alpine.DEB.2.02.1305011358500.19189@chino.kir.corp.google.com>
 <20130501211011.GD4466@pd.tnic>
 <alpine.DEB.2.02.1305011419020.20298@chino.kir.corp.google.com>
 <20130501215604.GA15623@pd.tnic>
 <alpine.DEB.2.02.1305011503200.3267@chino.kir.corp.google.com>
 <20130501222850.GB15623@pd.tnic>
 <alpine.DEB.2.02.1305011531320.8804@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305011531320.8804@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 03:37:28PM -0700, David Rientjes wrote:
> It means your patch is incomplete.

I'll gladly test and ack a patch which makes it complete.

Simple exercises in rhetoric about what does and what doesn't make sense
means a rat's ass to me. You need to show me a *real* use case which you
*actually* hit and this patch breaks it.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
