Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3GVBay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:30:54 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59673 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab3GVBaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:30:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: [GIT PULL] ACPI video support fixes for v3.11
Date: Mon, 22 Jul 2013 03:40:49 +0200
Message-ID: <2237114.mjSrxNP3xp@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+55aFw_XKDjPdrY9cwf99n4G_FN3Y3HbGT8HB=pRxLHgTDeJA@mail.gmail.com>
References: <32735792.sAmhGYT8HA@vostro.rjw.lan> <CA+55aFw_XKDjPdrY9cwf99n4G_FN3Y3HbGT8HB=pRxLHgTDeJA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 21, 2013 10:15:31 AM Linus Torvalds wrote:
> On Sat, Jul 20, 2013 at 5:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > I'm sending a separate pull request for this as it may be somewhat
> > controversial.
> 
> Ugh. That's an understatement, and I hate the timing.

Sorry about that.

The choice was between sending it now and sitting on it until the 3.12 merge
window pretty much without any additional data points.

> That said, it looks like it should be easy to revert if it causes
> problems, and I guess it won't become better from waiting until the
> next merge window.

Precisely.

> And the problems are hopefully going to be pretty easily pinpointed to
> this.. So I've pulled it.

Thanks a lot!

Rafael

