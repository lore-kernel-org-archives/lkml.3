Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaBZNwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:52:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34221 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaBZNwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:52:23 -0500
Date: Wed, 26 Feb 2014 14:52:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Message-ID: <20140226135217.GD22639@pd.tnic>
References: <20140224162400.GE16457@pd.tnic>
 <2875232.vjGVheuNuC@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2875232.vjGVheuNuC@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 02:57:16PM +0100, Rafael J. Wysocki wrote:
> On Monday, February 24, 2014 05:24:00 PM Borislav Petkov wrote:
> > This started happening this morning after booting -rc4+tip, let's
> > add *everybody* to CC :-)
> 
> What about -rc4 without tip?

I don't think so because

commit b9e1ab6d4c0582cad97699285a6b3cf992251b00
Author: Stephane Eranian <eranian@google.com>
Date:   Tue Feb 11 16:20:12 2014 +0100

    perf/x86/uncore: add SNB/IVB/HSW client uncore memory controller support

in -tip introduces that snb_uncore_imc_init_box() thing which causes the
ioremap conflict.

Btw, see my last email on this thread for more details about what I'm
seeing here.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
