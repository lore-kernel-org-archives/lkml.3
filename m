Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbaAGA1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:27:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53914 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaAGA1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:27:37 -0500
Date: Tue, 7 Jan 2014 01:27:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUERY] Power consumption on a 2013 MBP
Message-ID: <20140107002735.GE24243@amd.pavel.ucw.cz>
References: <CALkWK0n0q+a9EmMbJXsgo6eO1B+0Lq6tqsN3moLbXz+Y0GGu0g@mail.gmail.com>
 <20140106211115.GA23421@amd.pavel.ucw.cz>
 <CALkWK0nLg9D+4=_eNe3cgmnuzzZgk+E5U_OK9vh6_3XTZSX12w@mail.gmail.com>
 <20140106213630.GC14927@amd.pavel.ucw.cz>
 <CALkWK0kFRS2ZhsNdmBLms-XzpJ-5mc+--NFhx-tM==H2qrfXmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0kFRS2ZhsNdmBLms-XzpJ-5mc+--NFhx-tM==H2qrfXmQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-01-07 04:35:04, Ramkumar Ramachandra wrote:
> Pavel Machek wrote:
> > "Should not". Exactly. Your machine should not consume 20W. It does,
> > so try rmmoding USB modules, and probably AHCI...
> 
> My system freezes if I remove modules like usbhci, ahci, ehci_hcd.

Umm. Try harder. Like booting init=/bin/bash and not inserting them in
the first place.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
