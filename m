Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaDMC4w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 22:56:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:22034 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbaDMC4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 22:56:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,849,1389772800"; 
   d="scan'208";a="519583046"
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
	<CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
	<CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>
	<CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>
	<CAMzpN2jn69_E7UEP6OHBbc4r7UuJbsW50WA25YhXuQs5sHFxQQ@mail.gmail.com>
	<6f5f98f2-aa96-433f-9ee8-5ba216624957@email.android.com>
	<20140412193541.GA30697@pd.tnic>
	<21a22ace-fbc3-4f97-a277-9cdf4f2253eb@email.android.com>
	<CA+55aFy8s7cfaAXJ7WyJ4aMpBnsWGt2mA1=pduQwK+ofkvbzVg@mail.gmail.com>
	<5349BD3F.6000402@zytor.com>
Date: Sat, 12 Apr 2014 19:56:48 -0700
In-Reply-To: <5349BD3F.6000402@zytor.com> (H. Peter Anvin's message of "Sat,
	12 Apr 2014 15:25:03 -0700")
Message-ID: <87lhvahr7z.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
>
> But yes, we can make it configurable, but the default should almost
> certainly be off.

Why? Either it works or it doesn't.

If it works it doesn't make any sense to have a sysctl.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
