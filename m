Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3C1Tda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 15:33:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39916 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab3C1Td3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 15:33:29 -0400
Date: Thu, 28 Mar 2013 20:33:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Olof Johansson <olof@lixom.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.9-rc1 regression in arm dtb build
Message-ID: <20130328193323.GA25166@amd.pavel.ucw.cz>
References: <20130306193332.GA6022@amd.pavel.ucw.cz>
 <5137C404.9060902@wwwdotorg.org>
 <20130307144506.GB7344@amd.pavel.ucw.cz>
 <5138FDAE.8060202@wwwdotorg.org>
 <20130311050546.GA21863@quad.lixom.net>
 <CACxGe6vkC7fjzf1-+K8O81+w=jQ63PvuTEhSPyitEBA9XiKYnw@mail.gmail.com>
 <20130328092916.GA11187@amd.pavel.ucw.cz>
 <51545870.4010209@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51545870.4010209@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-03-28 08:49:20, Stephen Warren wrote:
> On 03/28/2013 03:29 AM, Pavel Machek wrote:
> ...
> > There's change that makes it pretty much impossible to build dtbs
> > reliably between different kernel versions, because it leaves old dtbs
> > around, and they survive even make clean.
> 
> One question here: Presumably the dtbs don't survive "make clean" if you
> run that right after building the dtbs, but only if you check out a new
> kernel version before running clean? Or is that not the case?

That was the case I seen, yes.

Have old kernel running, dtbs building. Apply a patch. It starts
behaving weird. You do make clean... but you still get old dtbs.

(It would be nice if make socfpga_cyclone5.dtb would magically remove
all the dtbs from old location; make dtbs does that if I understand
stuff correctly).

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
