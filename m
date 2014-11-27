Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750926AbaK0WeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 17:34:07 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:41870 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaK0WeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 17:34:05 -0500
MIME-Version: 1.0
In-Reply-To: <1803282.Wzz7IausxS@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1411271216470.8104-100000@netrider.rowland.org>
	<1803282.Wzz7IausxS@vostro.rjw.lan>
Date: Thu, 27 Nov 2014 23:34:03 +0100
Message-ID: <CAPDyKFpcHawZ8F+2QdDYO=+qbh=uQb+A+2Rq_M7g9VqMnFtM1A@mail.gmail.com>
Subject: Re: [PATCH 0/4] PM: Use CONFIG_PM instead of CONFIG_PM_RUNTIME in
 core code
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Kevin Hilman <khilman@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> That said whether or not it is ever useful to set PM_RUNTIME alone is a good
> question.  In my opinion it is useful today, at least on some platforms that
> don't really support system suspend or hibernation in any form.  However, it
> may not be the case any more when suspend-to-idle becomes mature enough,
> because that should just work for any platform without any kind of special
> support.  We're still missing some timekeeping bits there, but once that
> gap has been covered, we may just eliminate PM_SLEEP as well if there's a
> broad consensus on that.

That's sounds like a good approach, thanks for sharing your ideas and plans.

Feel free to add my reviewed-by tag to this patchset as well.

Kind regards
Uffe
