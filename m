Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbaBZNuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:50:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46120 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaBZNuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:50:51 -0500
Date: Wed, 26 Feb 2014 14:50:32 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Borislav Petkov <bp@alien8.de>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Message-ID: <20140226135032.GC30956@twins.programming.kicks-ass.net>
References: <20140224162400.GE16457@pd.tnic>
 <2875232.vjGVheuNuC@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2875232.vjGVheuNuC@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 02:57:16PM +0100, Rafael J. Wysocki wrote:
> On Monday, February 24, 2014 05:24:00 PM Borislav Petkov wrote:
> > This started happening this morning after booting -rc4+tip, let's
> > add *everybody* to CC :-)
> 
> What about -rc4 without tip?

The driver causing this is new and lives in -tip.
