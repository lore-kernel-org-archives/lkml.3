Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaB0K1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:27:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40281 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbaB0K12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:27:28 -0500
Date: Thu, 27 Feb 2014 11:27:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stephane Eranian <eranian@google.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, "H. Peter Anvin" <hpa@zytor.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        x86 <x86@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Message-ID: <20140227102722.GD18191@pd.tnic>
References: <20140225163010.GG24636@pd.tnic>
 <CABPqkBT3O2VwV48OC9TgCLKrEnC_qokxU8_odMZQ+d+55wdKgA@mail.gmail.com>
 <20140225173946.GH24636@pd.tnic>
 <CABPqkBTk+KA2kd7Qge2SkNXebDoh9Ntc2L_E3p2k42sbMxoYXw@mail.gmail.com>
 <20140225221027.GB21559@pd.tnic>
 <CABPqkBSH-cHDZ16y0WMyJ2e-kmJ6G_8DkJXPDa7pc4Hp63xG4g@mail.gmail.com>
 <20140226092903.GA22639@pd.tnic>
 <CABPqkBTxQpihn574NArDri0q8ZAOZxXSCSTBfoYfnSxjUH6q6g@mail.gmail.com>
 <20140226095956.GB22639@pd.tnic>
 <CABPqkBS04H6GOT4prZ3v=YZMdj=3KHkW77ON67p8f_Wor17kpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABPqkBS04H6GOT4prZ3v=YZMdj=3KHkW77ON67p8f_Wor17kpw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 11:12:32AM +0100, Stephane Eranian wrote:
> My Lenovo IVB is like yours. But I tried on my SandyBridge desktop and
> there to BAR is at a completely different address. Same thing on my
> Haswell desktop system.

Hrrm, I'd like to see what Rafael finds out, whether what we're reading
from PCI config space is even sane.

> As a asides, my SNB and HSW desktops with 3.14-rc4 are totally
> unstable. They hang if I type make in my kernel tree. Whereas 3.14-rc3
> is stable. I am not so sure this is all related to the uncore IMC
> support, though.

Easy to test - just disable the uncore thing.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
