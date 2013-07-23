Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934451Ab3GWXrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:47:25 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36622 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933940Ab3GWXrY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 19:47:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rafael.j.wysocki@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [v3.11-rc2] regression: brightness always on maximum.
Date: Wed, 24 Jul 2013 01:57:25 +0200
Message-ID: <24129555.GbVZ9SDS5Q@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CADDKRnBRyJZCoy3G53b6tY7J21XZp5bGn7nJi87WUgEGhSuT_w@mail.gmail.com>
References: <CADDKRnBRyJZCoy3G53b6tY7J21XZp5bGn7nJi87WUgEGhSuT_w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 23, 2013 09:52:15 AM Jörg Otte wrote:
> The brightness of my laptop is always on maximum and can't be scaled
> down.
> Brightness control via function keys was always working on this
> laptop, so this is a regression in v3.11-rc2.

Is there any other way to control brightness on your system (eg. through a GUI)?

If so, does it work?

Also, does reverting commit efaa14c help?  If it doesn't help, does reverting
commit 8c5bd7a too (so that both are reverted) help?

Rafael

