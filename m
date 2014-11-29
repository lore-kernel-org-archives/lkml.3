Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaK2A25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 19:28:57 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56986 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751366AbaK2A2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 19:28:55 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Kevin Hilman <khilman@kernel.org>
Subject: Re: [PATCH 0/4] PM: Use CONFIG_PM instead of CONFIG_PM_RUNTIME in core code
Date: Sat, 29 Nov 2014 01:50:12 +0100
Message-ID: <2549404.ZIjrAGNJPJ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAPDyKFpcHawZ8F+2QdDYO=+qbh=uQb+A+2Rq_M7g9VqMnFtM1A@mail.gmail.com>
References: <Pine.LNX.4.44L0.1411271216470.8104-100000@netrider.rowland.org> <1803282.Wzz7IausxS@vostro.rjw.lan> <CAPDyKFpcHawZ8F+2QdDYO=+qbh=uQb+A+2Rq_M7g9VqMnFtM1A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 27, 2014 11:34:03 PM Ulf Hansson wrote:
> [...]
> 
> > That said whether or not it is ever useful to set PM_RUNTIME alone is a good
> > question.  In my opinion it is useful today, at least on some platforms that
> > don't really support system suspend or hibernation in any form.  However, it
> > may not be the case any more when suspend-to-idle becomes mature enough,
> > because that should just work for any platform without any kind of special
> > support.  We're still missing some timekeeping bits there, but once that
> > gap has been covered, we may just eliminate PM_SLEEP as well if there's a
> > broad consensus on that.
> 
> That's sounds like a good approach, thanks for sharing your ideas and plans.
> 
> Feel free to add my reviewed-by tag to this patchset as well.

I'll do that, thanks!

