Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbaGFKTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 06:19:22 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:49717 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbaGFKTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 06:19:20 -0400
Message-ID: <1404641957.24853.14.camel@x220>
Subject: Re: [PATCH] kconfig: store default ARCH in .config
From: Paul Bolle <pebolle@tiscali.nl>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Sun, 06 Jul 2014 12:19:17 +0200
In-Reply-To: <CALYGNiP3EREk4yDqnduuDhOsJLHFwZK4D1QGLd+u5edEk2JFOA@mail.gmail.com>
References: <20140706080234.19520.96704.stgit@zurg>
	 <1404637557.24853.12.camel@x220>
	 <CAMuHMdWUpqz0W_znrrm2Qp+QjKExQ5Gcv0OsuA4gJa1Wvjv06A@mail.gmail.com>
	 <CALYGNiP3EREk4yDqnduuDhOsJLHFwZK4D1QGLd+u5edEk2JFOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jul 2014 10:19:18.0035 (UTC) FILETIME=[BEB26E30:01CF9903]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-06 at 14:02 +0400, Konstantin Khlebnikov wrote:
> On Sun, Jul 6, 2014 at 1:08 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Sun, Jul 6, 2014 at 11:05 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> >> Could the same result be had by saving CONFIG_ARCH in .config (I suppose
> >> it actually already is) and then use its value on builds with
> >
> > No, currently it's not saved in .config, so I guess that's why this convoluted
> > approach is needed.
> 
> Yep, kconfig neither reads nor writres symbols with option env=...
> 
> >
> >> that .config unless ARCH is specified in the environment again? Ie,
> >> change the "option env=[...]" semantics a bit, perhaps by special casing
> >> CONFIG_ARCH.
> >
> > Indeed.
> 
> If it's saved in config value might be out of sync with actual environment:
> ARCH != CONFIG_ARCH. So, behaviour becomes too complicated.

So let the environment overrules what is saved in the .config. What
makes that complicated?


Paul Bolle

