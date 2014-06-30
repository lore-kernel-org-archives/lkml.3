Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaF3PPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:15:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52573 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaF3PPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:15:48 -0400
Date: Mon, 30 Jun 2014 17:15:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org, =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: [PATCH] KVM: SVM: Fix CPL export via SS.DPL
Message-ID: <20140630151544.GF4766@pd.tnic>
References: <53B0050B.90104@web.de>
 <20140629131443.GA5199@pd.tnic>
 <20140629134247.GG18167@minantech.com>
 <20140629140104.GB12528@pd.tnic>
 <20140629142722.GH18167@minantech.com>
 <53B02395.8030505@web.de>
 <53B027E0.7040003@web.de>
 <53B02CEB.7010607@web.de>
 <53B17BDD.5030301@redhat.com>
 <53B17C5D.5050407@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53B17C5D.5050407@web.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 05:03:57PM +0200, Jan Kiszka wrote:
> 15.5.1:
> 
> "When examining segment attributes after a #VMEXIT:
> [...]
> • Retrieve the CPL from the CPL field in the VMCB, not from any segment
> DPL."

Heey, it is even documented! :-P

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
