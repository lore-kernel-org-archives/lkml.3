Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab3FEWK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:10:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54574 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757879Ab3FEWK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 18:10:56 -0400
Date: Thu, 6 Jun 2013 00:10:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 4/4] microcode/x86/amd: early microcode patch loading
 support for AMD
Message-ID: <20130605221042.GE29856@pd.tnic>
References: <1369940959-2077-1-git-send-email-jacob.shin@amd.com>
 <1369940959-2077-5-git-send-email-jacob.shin@amd.com>
 <20130531042649.GA4488@khazad-dum.debian.net>
 <20130531193200.GA8346@alberich>
 <20130531213039.GA13307@khazad-dum.debian.net>
 <20130601011512.GA8532@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130601011512.GA8532@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 08:15:12PM -0500, Jacob Shin wrote:
> Any thoughts on this Boris?

Looks ok to me - I'm assuming you're testing all this new code on all
families...?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
