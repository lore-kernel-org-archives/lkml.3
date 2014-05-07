Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbaEGKSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 06:18:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46159 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbaEGKSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 06:18:20 -0400
Date: Wed, 7 May 2014 12:18:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Alexandre Julliard <julliard@winehq.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
Message-ID: <20140507101815.GA16725@pd.tnic>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
 <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
 <CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
 <CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>
 <CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>
 <87k3aspd1h.fsf@wine.dyndns.org>
 <87zjiuymiu.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87zjiuymiu.fsf@turtle.gmx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 11:18:49AM +0200, Sven Joachim wrote:
> I would rather not set up a virtual machine just for wine (I don't
> have Windows anymore).

What about reactos? (I'm not saying this shouldn't be addressed,
regardless...)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
