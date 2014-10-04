Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbaJDLYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 07:24:22 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:4005 "EHLO
	esgaroth.tuxoid.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaJDLYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 07:24:20 -0400
X-Greylist: delayed 3476 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Oct 2014 07:24:20 EDT
Subject: Re: Why do we still have 32 bit counters? Interrupt counters
 overflow within 50 days
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Christoph Lameter <cl@linux.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Date: Sat, 04 Oct 2014 12:26:09 +0200
In-Reply-To: <alpine.DEB.2.11.1410030722390.9084@gentwo.org>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org>
	 <alpine.DEB.2.11.1410031231420.4383@nanos>
	 <alpine.DEB.2.11.1410030653040.8496@gentwo.org>
	 <1412338512.19413.85.camel@x220>
	 <alpine.DEB.2.11.1410030722390.9084@gentwo.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1412418370.19330.10.camel@thorin>
Mime-Version: 1.0
X-DCC-EATSERVER-Metrics: esgaroth.tuxoid.at 1166; Body=4 Fuz1=4 Fuz2=4
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.2 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fre, 2014-10-03 at 07:23 -0500, Christoph Lameter wrote:
> On Fri, 3 Oct 2014, Paul Bolle wrote:
> 
> > dc -e "1 k 2 32 ^ 1000 / 86400 / p"
> > 49.7
> >
> > (That was the number I remembered from stories about a ancient Windows
> > lockup.)
> 
> Well yes, I used bc which discards the remainder on integer divides

Use `bc -l`;-)
----  snip  ----
2^32 / 1000 / 86400 
49.71026962962962962962
----  snip  ----

	Bernd
-- 
"I dislike type abstraction if it has no real reason. And saving
on typing is not a good reason - if your typing speed is the main
issue when you're coding, you're doing something seriously wrong."
    - Linus Torvalds

