Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbaAFVgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:36:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52259 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529AbaAFVgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:36:31 -0500
Date: Mon, 6 Jan 2014 22:36:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUERY] Power consumption on a 2013 MBP
Message-ID: <20140106213630.GC14927@amd.pavel.ucw.cz>
References: <CALkWK0n0q+a9EmMbJXsgo6eO1B+0Lq6tqsN3moLbXz+Y0GGu0g@mail.gmail.com>
 <20140106211115.GA23421@amd.pavel.ucw.cz>
 <CALkWK0nLg9D+4=_eNe3cgmnuzzZgk+E5U_OK9vh6_3XTZSX12w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0nLg9D+4=_eNe3cgmnuzzZgk+E5U_OK9vh6_3XTZSX12w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-01-07 02:47:18, Ramkumar Ramachandra wrote:
> Pavel Machek wrote:
> > USB usually does that. Try rmmoding hcd(s). If that does not help, try
> > removing other modules. Oh and try without that broadcom-wl driver.
> 
> Unused modules shouldn't consume so much power, no? I suspected
> broadcom-wl, but removing it doesn't help. Instead of shooting in the
> dark, is there some tool that I can use to figure out the culprits?

"Should not". Exactly. Your machine should not consume 20W. It does,
so try rmmoding USB modules, and probably AHCI...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
