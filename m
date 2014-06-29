Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaF2SAj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 14:00:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59335 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbaF2SAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 14:00:37 -0400
Date: Sun, 29 Jun 2014 20:00:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org, =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: [PATCH] KVM: SVM: Fix CPL export via SS.DPL
Message-ID: <20140629180033.GA12943@pd.tnic>
References: <53AFF192.7020801@web.de>
 <20140629115143.GA4362@pd.tnic>
 <53B0050B.90104@web.de>
 <20140629131443.GA5199@pd.tnic>
 <20140629134247.GG18167@minantech.com>
 <20140629140104.GB12528@pd.tnic>
 <20140629142722.GH18167@minantech.com>
 <53B02395.8030505@web.de>
 <53B027E0.7040003@web.de>
 <53B02CEB.7010607@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53B02CEB.7010607@web.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 05:12:43PM +0200, Jan Kiszka wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> We import the CPL via SS.DPL since ae9fedc793. However, we fail to
> export it this way so far. This caused spurious guest crashes, e.g. of
> Linux when accessing the vmport from guest user space which triggered
> register saving/restoring to/from host user space.
> 
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>

Yep, looks good.

Tested-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
