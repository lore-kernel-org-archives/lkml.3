Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaLNJsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 04:48:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42379 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaLNJsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 04:48:01 -0500
Date: Sun, 14 Dec 2014 10:47:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: Re: bluetooth: Add hci_h4p driver
Message-ID: <20141214094757.GA28973@amd>
References: <20141213223727.GA13894@amd>
 <570BAC61-3137-42E5-B4F8-A61AEED380DE@holtmann.org>
 <20141213235131.GA23566@amd>
 <ED6FB9B5-7BD5-4398-ACA4-C5D1547B91A4@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ED6FB9B5-7BD5-4398-ACA4-C5D1547B91A4@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-12-14 01:07:42, Marcel Holtmann wrote:
> Hi Pavel,
> 
> >>> My notes say that Marcel wanted different filenames, but I'd need
> >>> advice exactly what filenames. I guess platform data supprort should
> >>> be removed altogether, rather than renamed.
> >> 
> >> Yes, the platform support should go away. This should be purely based on DT.
> >> 
> >> Can you also start using git format-patch so that patches get a diffstat.
> > 
> > So the rest of filenames look ok?
> 
> I have not looked at the patch or the filenames at all.

Ok, so here's diffstat. Can you take a look?

Thanks,
									Pavel

 drivers/bluetooth/Kconfig                  |   10 
 drivers/bluetooth/Makefile                 |    3 
 drivers/bluetooth/hci_h4p.h                |  234 +++++
 drivers/bluetooth/nokia_core.c             | 1262 +++++++++++++++++++++++++++++
 drivers/bluetooth/nokia_fw-bcm.c           |   27 
 drivers/bluetooth/nokia_fw.c               |  105 ++
 drivers/bluetooth/nokia_uart.c             |  179 ++++
 include/linux/platform_data/bt-nokia-h4p.h |    4 
 8 files changed, 1822 insertions(+), 2 deletions(-)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
