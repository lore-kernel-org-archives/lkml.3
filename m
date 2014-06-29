Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaF2NqO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 09:46:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43886 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbaF2NqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 09:46:12 -0400
Date: Sun, 29 Jun 2014 15:46:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org, =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: __schedule #DF splat
Message-ID: <20140629134609.GA12528@pd.tnic>
References: <20140628114431.GB4373@pd.tnic>
 <20140629064626.GD18167@minantech.com>
 <53AFE2B3.5080300@web.de>
 <20140629102403.GE18167@minantech.com>
 <53AFEB16.5040608@web.de>
 <20140629105339.GF18167@minantech.com>
 <53AFF192.7020801@web.de>
 <20140629115143.GA4362@pd.tnic>
 <53B0050B.90104@web.de>
 <20140629131443.GA5199@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140629131443.GA5199@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 03:14:43PM +0200, Borislav Petkov wrote:
> I better go and revert that one and check whether it fixes things.

Yahaaa, that was some good bisection work Jan! :-)

> 20 guest restart cycles and all is fine - it used to trigger after 5
max.

Phew, we have it right in time before the football game in 2 hrs. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
