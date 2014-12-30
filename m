Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaL3PDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 10:03:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbaL3PDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 10:03:50 -0500
Date: Tue, 30 Dec 2014 16:03:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Emmanuel Grumbach <egrumbach@gmail.com>
cc: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iwlwifi-driver card doesn't work with 3.19-rc2+
In-Reply-To: <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1412301600520.31609@pobox.suse.cz>
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz> <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2014, Emmanuel Grumbach wrote:

> > I just booted current Linus' tree (5faa0154fe33) on my x200s thinkpad, and
> > wifi doesn't work. iwconfig is telling me that wlan0 interface has no
> > wireless extensions.
> 
> So why do you used them?
> They have been deprecated for a couple of years now. You should be
> using nl80211 based tools such as iw.

My userspace wireless setup tool (wicd) is using wireless extensions, and 
even the most recent version uses solely that.

I am pretty sure that's not the only tool in the world.

> > Previous kernel that is known to work on this machine is 3.18-rc5. I 
> > can do a bisect if needed, but wanted to ask in case this is a known 
> > problem.
> 
> 3.19 is the first kernel that actually removed the wireless extensions.

That's userspace breakage I am pretty sure a LOT of people will be 
hitting. I don't think this fits into the way we are maintaining userspace 
compatibility at all.

-- 
Jiri Kosina
SUSE Labs
