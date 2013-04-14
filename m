Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab3DNLDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 07:03:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35730 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab3DNLD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 07:03:29 -0400
Date: Sun, 14 Apr 2013 13:03:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>
Subject: Re: [PATCH] x86: Add a Kconfig shortcut for a kvm-bootable kernel
Message-ID: <20130414110320.GB20547@pd.tnic>
References: <20130412181956.GA13099@pd.tnic>
 <516A7760.7030907@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <516A7760.7030907@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 14, 2013 at 12:31:12PM +0300, Pekka Enberg wrote:
> I obviously support having something like this in mainline. I wonder
> though if we could just call this "default standalone KVM guest
> config" instead of emphasizing testing angle.

/me nods agreeingly...

And it should be unter HYPERVISOR_GUEST where the rest of this stuff
resides. Good point.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
