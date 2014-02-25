Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaBYQaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 11:30:16 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60887 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbaBYQaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:30:14 -0500
Date: Tue, 25 Feb 2014 17:30:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stephane Eranian <eranian@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        x86 <x86@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Message-ID: <20140225163010.GG24636@pd.tnic>
References: <20140224162400.GE16457@pd.tnic>
 <20140224201943.GA4397@pd.tnic>
 <530CBB3D.3080604@zytor.com>
 <CABPqkBR4bR9U1bhTtA02gDVR0aZ7iXBfg87jPLHfhrZVeFF8_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABPqkBR4bR9U1bhTtA02gDVR0aZ7iXBfg87jPLHfhrZVeFF8_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 05:14:01PM +0100, Stephane Eranian wrote:
> I am trying to understand your test case.
> Were you actually measure uncore_imc events at the time you suspended?

No test case, just the machine booting; look at the printk timestamps.

> I tried on my IvyBridge Lenovo and it works fine with 3.14-rc4+
> (tip.git). I used: echo -n disk >/sys/power/state

That's an x230 too, right? What I do is, I take linus/master, merge
tip/master, Matt's efi/next tree and my edac/for-next tree into it and
then boot that.

I don't think that the edac and efi trees interfere though. I'll do a
fresh merge of only current tip/master into linus/master to test hpa's
suggestion in the other mail.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
