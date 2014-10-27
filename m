Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaJ0Jbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:31:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48146 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaJ0Jbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:31:47 -0400
Date: Mon, 27 Oct 2014 10:31:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Marek Belisko <marek@goldelico.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/2] Documentation: devicetree: Add bindings for Wi2Wi
 w2sg0004 gps
Message-ID: <20141027093126.GC9807@amd>
References: <1413491183-15018-1-git-send-email-marek@goldelico.com>
 <1413491183-15018-2-git-send-email-marek@goldelico.com>
 <20141017093714.GB4202@leverpostej>
 <D65FF64A-856F-47EC-B3DE-7F2FCE505087@goldelico.com>
 <20141017110043.GA5335@leverpostej>
 <27AD2801-6410-44E3-9E0C-911D73E6A457@goldelico.com>
 <20141020093536.GA25360@leverpostej>
 <7A9F8C73-6CBD-435A-934C-14A80FFE452F@goldelico.com>
 <FDDD1C99-81F9-4933-815A-CC686A19115E@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FDDD1C99-81F9-4933-815A-CC686A19115E@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > I think we just disagree about implementing a version that “works” in a quite specific
> > setup (there are necessary assumptions about OMAP pinmux and omap-serial) with
> > existing APIs versus a general one that might need a lot of changes outside the driver
> > and introduce new APIs.
> 
> After re-thinking what we have discussed so far (and considering other recommendations
> I have received off-list) I currently see these options/questions:
> 
> * who could modify the serial drivers and APIs so that this driver can become
>   a subnode (“bus client”) of an UART? How long does it take to
> become available?

I believe that is called "tty line discipline".

> * would it be an option to simply rename the driver to “w2sg0004-power”
>   to make clear that it is not at all related to the UART data communication
>   channel but only controlling the power of the w2sg0004 chip?

Sounds sane.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
