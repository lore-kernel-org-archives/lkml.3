Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbaLMXvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 18:51:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38739 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaLMXvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 18:51:33 -0500
Date: Sun, 14 Dec 2014 00:51:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        linux-bluetooth@vger.kernel.org
Subject: Re: bluetooth: Add hci_h4p driver
Message-ID: <20141213235131.GA23566@amd>
References: <20141213223727.GA13894@amd>
 <570BAC61-3137-42E5-B4F8-A61AEED380DE@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <570BAC61-3137-42E5-B4F8-A61AEED380DE@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > My notes say that Marcel wanted different filenames, but I'd need
> > advice exactly what filenames. I guess platform data supprort should
> > be removed altogether, rather than renamed.
> 
> Yes, the platform support should go away. This should be purely based on DT.
> 
> Can you also start using git format-patch so that patches get a diffstat.

So the rest of filenames look ok?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
