Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaKDNzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:55:45 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52469 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750866AbaKDNzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:55:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Timur Tabi <timur@codeaurora.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
Date: Tue, 04 Nov 2014 15:16:28 +0100
Message-ID: <1905537.TSPKRBptT4@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACRpkdaZYubzEKVKiG4vCnh2kDr7CfRvaXcJNHSFtSUaRdXW4A@mail.gmail.com>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com> <4832015.R1NooRni06@vostro.rjw.lan> <CACRpkdaZYubzEKVKiG4vCnh2kDr7CfRvaXcJNHSFtSUaRdXW4A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 04, 2014 02:48:27 PM Linus Walleij wrote:
> On Tue, Nov 4, 2014 at 2:31 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Tuesday, November 04, 2014 11:39:07 AM Mika Westerberg wrote:
> 
> >> For reference the latest ACPI _DSD patches can be found here
> >>
> >> https://lkml.org/lkml/2014/10/21/762
> >
> > Actually, it's better to pull the device-properties branch:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git device-properties
> >
> > because that contains the lastest changes.  It will be rebased in the future,
> > though, so don't merge it into your "immutable" branches.
> 
> I've landed these two patches for v3.19, I guess we can wait for the
> device properties to land properly upstream before proceeding
> with ACPI support ...?

That would be reasonable IMO.

> Or are you guys working with one finger constantly on the fast-forward button? :D

We hoped we'd be able to get the device properties patchset in earlier.
Unfortunately, that didn't happen and is kind of blocking stuff as you can see.

Rafael

