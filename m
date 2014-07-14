Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaGNRgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:36:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbaGNRf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:35:56 -0400
Date: Mon, 14 Jul 2014 19:35:41 +0200
From: Borislav Petkov <bp@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        matt.fleming@intel.com
Subject: Re: [PATCH] x86: Configure NX support earlier in setup_arch
Message-ID: <20140714173541.GF25120@pd.tnic>
References: <53B4B627.8060903@gmail.com>
 <53BC7210.1000305@gmail.com>
 <53BC72D8.4090705@zytor.com>
 <53BDE4BD.50605@gmail.com>
 <20140714172225.GE25120@pd.tnic>
 <4de57990-9efc-4ead-b95e-a0d25b86e703@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4de57990-9efc-4ead-b95e-a0d25b86e703@email.android.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:28:43AM -0700, H. Peter Anvin wrote:
> Oh, it is a case of Grub2 utter braindamage. That figures. I guess we
> need to invoke verify_cpu in yet another place.

How so? The bug report speaks of disabling NX in the BIOS, I'm assuming
they're setting bit 34 in IA32_MISC_ENABLE.

How would that affect grub2?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
