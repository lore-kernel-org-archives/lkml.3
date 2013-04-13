Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab3DMUHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 16:07:31 -0400
Received: from tex.lwn.net ([70.33.254.29]:54160 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab3DMUHa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 16:07:30 -0400
Date: Sat, 13 Apr 2013 14:07:28 -0600
From: Jake Edge <jake@lwn.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: "Rafael J.Wysocki" <rjw@sisk.pl>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Roberto Oppedisano <roberto.oppedisano@gmail.com>,
        Ville Syrjala <syrjala@sci.fi>,
        Salvatore Sisinni <s.sisinni@gmail.com>, auxsvr@gmail.com
Subject: Re: still in 3.9-rc6 - fan speed at 100% after suspend/resume
 regression
Message-ID: <20130413140728.038e4b15@chukar.edge2.net>
In-Reply-To: <1365877215.2221.8.camel@rzhang1-mobl4>
References: <20130413100221.70c040fa@chukar.edge2.net>
 <1365877215.2221.8.camel@rzhang1-mobl4>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.16; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ not sure why, but the lkml address got munged in Rui's reply ...
fixed now -- sorry for the dupe ]

On Sun, 14 Apr 2013 02:20:15 +0800 Zhang Rui wrote:

> > A brief recap: after resuming, the fan on the laptop spins up to
> > full speed and stays there. "temp6" in "acpitz-virtual-0" (as shown
> > by "sensors") is 100°C and stays there, which is presumably what is
> > making the fan stay on.
> > 
> first, this seems like the same problem reported at
> https://bugzilla.kernel.org/show_bug.cgi?id=50041
> please refer to comment #17 and #27.

Yes, it does seem like the same bug that Matthias is talking about in
those comments ...
 
> > Is more information needed?
> > 
> please attach the acpidump output of your laptop.

I have the dump, do you want it on the old closed bug or shall I wait
until Matthias opens a new one?

> can you please test thermal -thermal branch at
> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git

I just tried it, no difference in behavior (fan on full, temp6 ==
100°C) ...

I took all the defaults when I did a 'make oldconfig', some of which
looked thermal-related ... was I supposed to set them differently?

thanks,

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
