Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaDAUiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:38:24 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56800 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaDAUiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:38:22 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [git pull] Devicetree changes for v3.15
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@linaro.org>
In-Reply-To: <1396381357.23763.16.camel@x220>
References: <CACxGe6vCrkHPL6UNy1p8AO4+z5VFRY6w4_2grQEZQwp_3jJ7Yw@mail.gmail. com> <1396381357.23763.16.camel@x220>
Date: Tue, 01 Apr 2014 21:32:50 +0100
Message-Id: <20140401203250.0B2A7C408A6@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Apr 2014 21:42:37 +0200, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Tue, 2014-04-01 at 11:15 +0100, Grant Likely wrote:
> > Grant Likely (13):
> >       [...]
> >       of: remove /proc/device-tree
> 
> That commit leaves a select for PROC_DEVICETREE dangling. See "config
> ARCH_OMAP2PLUS" in arch/arm/mach-omap2/Kconfig. Can that select
> statement just be dropped now or is something more elaborate needed?

I'll fix that up and submit a cleanup today. A dangling select should
not break the build.

g.

