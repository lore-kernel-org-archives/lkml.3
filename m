Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaB0V5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:57:17 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61851 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752536AbaB0V5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:57:14 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        x86 <x86@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Date: Thu, 27 Feb 2014 23:12:17 +0100
Message-ID: <6583599.OFJjbmgnW2@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140227102722.GD18191@pd.tnic>
References: <20140225163010.GG24636@pd.tnic> <CABPqkBS04H6GOT4prZ3v=YZMdj=3KHkW77ON67p8f_Wor17kpw@mail.gmail.com> <20140227102722.GD18191@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 27, 2014 11:27:22 AM Borislav Petkov wrote:
> On Thu, Feb 27, 2014 at 11:12:32AM +0100, Stephane Eranian wrote:
> > My Lenovo IVB is like yours. But I tried on my SandyBridge desktop and
> > there to BAR is at a completely different address. Same thing on my
> > Haswell desktop system.
> 
> Hrrm, I'd like to see what Rafael finds out, whether what we're reading
> from PCI config space is even sane.

I won't be able to look at that before Monday I'm afraid (personal stuff).

Rafael

