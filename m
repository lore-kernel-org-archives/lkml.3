Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbaDLLhE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 07:37:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42162 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbaDLLhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 07:37:01 -0400
Date: Sat, 12 Apr 2014 13:36:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Christian Grothoff <christian@grothoff.org>
Cc: Alejandra Morales <alejandra.morales@tum.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Cryogenic: Enabling Power-Aware Applications on Linux
Message-ID: <20140412113653.GA10806@Nokia-N900>
References: <9E3F9C2076C45D4783F09B90D5BE77CE1AEF7A@BADWLRZ-SWMBX13.ads.mwn.de>
 <20140411101926.GA27234@amd.pavel.ucw.cz>
 <534838E8.10005@grothoff.org>
 <20140411220517.GA1203@amd.pavel.ucw.cz>
 <53487FE7.2040604@grothoff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53487FE7.2040604@grothoff.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Yes, it depends on the device, but we have demonstrated power
> >> savings for two different types of devices using two different
> >> measurement setups performed by two independent groups.  Some
> >> of the measurements are available on the website, the second
> >> set should become available "soon" (but we can already say that
> >> for the scenario we measured, the savings are in the same range
> >> as before).
> > 
> > The video I seen.... AFAICT the savings are in <10% range?
> 
> For the scenario we scripted, yes. But note that we only
> allowed 50% of the packets transmitted to be delayed (a bit).
> If you were to increase the allowed delay or allowed a larger
> fraction of packets to be delayed, you should see larger savings.
> 
> > I seen demo on UDP packets... delayed TCP socket write is probably
> > easy, but would API allow delayed TCP connect?
> 
> Yes.
> 
> > Hmm, but the API needs redoing, anyway, fcntl()?
> 
> Depends --- while I like the idea, I did not hear enough to be
> certain that having this feature embedded in such a non-modular
> way was already the consensus (and I do not see a reasonable
> way to change the API this way while maintaining the modularity
> of the current code).

Being modular is not important for small piece of code like
this. Having reasonable interface is...

						Pavel
