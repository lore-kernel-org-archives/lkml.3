Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaDKWFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:05:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50989 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaDKWFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:05:19 -0400
Date: Sat, 12 Apr 2014 00:05:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Christian Grothoff <christian@grothoff.org>
Cc: Alejandra Morales <alejandra.morales@tum.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Cryogenic: Enabling Power-Aware Applications on Linux
Message-ID: <20140411220517.GA1203@amd.pavel.ucw.cz>
References: <9E3F9C2076C45D4783F09B90D5BE77CE1AEF7A@BADWLRZ-SWMBX13.ads.mwn.de>
 <20140411101926.GA27234@amd.pavel.ucw.cz>
 <534838E8.10005@grothoff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534838E8.10005@grothoff.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Cryogenic is the result of my Master's Thesis, completed at the Technical University
> >> of Munich under the supervision of Christian Grothoff. You can find more information
> >> about Cryogenic at https://gnunet.org/cryogenic
> > 
> > Do you have any measurements how much power it actually saves?
> 
> Yes, it depends on the device, but we have demonstrated power
> savings for two different types of devices using two different
> measurement setups performed by two independent groups.  Some
> of the measurements are available on the website, the second
> set should become available "soon" (but we can already say that
> for the scenario we measured, the savings are in the same range
> as before).

The video I seen.... AFAICT the savings are in <10% range?

> > "I'd like to download my mails from IMAP server in next 30
> > minutes. But... it would be better done when I'm on 3G network with
> > good signal (0.01W transmit power used for 3 seconds) than on GPRS
> > with poor signal (2W transmit power for 4 minutes)..."
> 
> Well, that's not quite what the API would allow, especially as it
> is obviously hard to predict that a different network will become
> available.

Actually... its a phone so it probably has GPS :-). But I'd guess that
even simpler logic, "if UMTS was available in last hour, it is likely
to be available within hour" would work ok.

I seen demo on UDP packets... delayed TCP socket write is probably
easy, but would API allow delayed TCP connect?

Hmm, but the API needs redoing, anyway, fcntl()?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
