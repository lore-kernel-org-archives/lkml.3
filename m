Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaIEWpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:45:16 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53824 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaIEWpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:45:13 -0400
Date: Fri, 5 Sep 2014 15:45:09 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Francis Moreau <francis.moro@gmail.com>, stable@vger.kernel.org,
        linux-pm@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 3.10.y+] PM / sleep: Use valid_state() for
 platform-dependent sleep states only
Message-ID: <20140905224509.GF18411@ld-irv-0074>
References: <1849024.CHOUso6H2K@vostro.rjw.lan>
 <1409865665-5375-1-git-send-email-computersforpeace@gmail.com>
 <54095835.7000207@gmail.com>
 <20140905074512.GA12218@brian-ubuntu>
 <20140905214758.GC30221@kroah.com>
 <20140905220828.GE18411@ld-irv-0074>
 <20140905223626.GA2376@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905223626.GA2376@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 03:36:26PM -0700, Greg Kroah-Hartman wrote:
> > > If they apply cleanly, then just list the git commit ids, and I can take
> > > care of the rest.
> > 
> > OK. Is this a policy that should be documented? AIUI, we have a few
> > options:
> > 
> >   1. Include 'Cc: stable@vger.kernel.org' in the original commit that
> >   gets to Linus
> > 
> >   2. Send an email to stable@vger.kernel.org that just contains the
> >   commit IDs, after they've made it to Linus
> > 
> >   3. Send patches to stable@vger.kernel.org, if backporting is not
> >   trivial
> > 
> > #1 is most common, and #2 seems like it would handle most of what misses
> > #1. #3 seems inferior, whenever #2 would suffice. But #2 is not in
> > stable_kernel_rules.txt.
> 
> I always gladly take patches to that .txt file if you wish to make it
> clearer.

I was interested in whether I had my facts straight before trying to
document them. I'll take your response to mean I'm not far off base, so
I'll take a stab at patching the file.

Thanks,
Brian
