Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab3EAXJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 19:09:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39923 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757553Ab3EAXJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 19:09:03 -0400
Date: Thu, 2 May 2013 01:09:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        Borislav Petkov <bp@suse.de>, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for
 building working KVM guest kernels
Message-ID: <20130501230901.GD15623@pd.tnic>
References: <20130501203500.GC4466@pd.tnic>
 <alpine.DEB.2.02.1305011358500.19189@chino.kir.corp.google.com>
 <20130501211011.GD4466@pd.tnic>
 <alpine.DEB.2.02.1305011419020.20298@chino.kir.corp.google.com>
 <20130501215604.GA15623@pd.tnic>
 <alpine.DEB.2.02.1305011503200.3267@chino.kir.corp.google.com>
 <20130501222850.GB15623@pd.tnic>
 <alpine.DEB.2.02.1305011531320.8804@chino.kir.corp.google.com>
 <20130501230254.GC15623@pd.tnic>
 <51819F6C.1030201@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51819F6C.1030201@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 04:04:12PM -0700, H. Peter Anvin wrote:
> The fundamental problem is that "select" is broken and doesn't track
> dependencies of things selected.

Yep, ancient history.

And yet, I'm using this option to do randconfig builds and then boot
them and I see almost no build breakages, at least none caused by this
Kconfig option.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
