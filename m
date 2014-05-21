Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaEUOFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:05:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49652 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaEUOFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:05:40 -0400
Date: Wed, 21 May 2014 16:05:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nishanth Menon <nm@ti.com>
Cc: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        dt list <devicetree@vger.kernel.org>
Subject: Re: [RFC] Migrate to Hz resolution for OPP binding
Message-ID: <20140521140538.GC15936@amd.pavel.ucw.cz>
References: <672dd8e9-2857-49fb-848f-d38d38b23c9b@BN1BFFO11FD024.protection.gbl>
 <CAGo_u6rftjYAEy0wSFA6aqCDNsriC9r-cMVSqeX1xqKCVBqe7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGo_u6rftjYAEy0wSFA6aqCDNsriC9r-cMVSqeX1xqKCVBqe7g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > As plan B, I was thinking to add the property 'operating-points-hz'...
> >
> > Any better ideas?
> 
> property operating-points-hz as a bool perhaps -> that modifies the
> description and maintains legacy dtb support sounds OK to me if DT
> folks and Rafael are ok with it as well.

That should like a terrible hack :-(.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
