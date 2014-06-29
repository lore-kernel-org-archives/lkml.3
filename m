Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaF2Lvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 07:51:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39807 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbaF2Lvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 07:51:45 -0400
Date: Sun, 29 Jun 2014 13:51:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org, =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: __schedule #DF splat
Message-ID: <20140629115143.GA4362@pd.tnic>
References: <20140627115545.GC23153@pd.tnic>
 <53AD5D27.2090505@redhat.com>
 <20140627121053.GD23153@pd.tnic>
 <20140628114431.GB4373@pd.tnic>
 <20140629064626.GD18167@minantech.com>
 <53AFE2B3.5080300@web.de>
 <20140629102403.GE18167@minantech.com>
 <53AFEB16.5040608@web.de>
 <20140629105339.GF18167@minantech.com>
 <53AFF192.7020801@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53AFF192.7020801@web.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 12:59:30PM +0200, Jan Kiszka wrote:
> Will see what I can do regarding bisecting. That host is a bit slow
> (netbook), so it may take a while. Boris will probably beat me in
> this.

Nah, I was about to instrument kvm_multiple_exception() first and am
slow anyway so... :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
