Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaBNPS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 10:18:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:29987 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbaBNPS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 10:18:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,845,1384329600"; 
   d="scan'208";a="483485095"
Date: Fri, 14 Feb 2014 17:26:01 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "ACPI / video: Add HP EliteBook Revolve 810 to
 the blacklist"
Message-ID: <20140214152601.GL5018@intel.com>
References: <1392381247-28109-1-git-send-email-mika.westerberg@linux.intel.com>
 <s5hmwht24ub.wl%tiwai@suse.de>
 <20140214140316.GI5018@intel.com>
 <s5hfvnl23pq.wl%tiwai@suse.de>
 <20140214141652.GJ5018@intel.com>
 <s5ha9dt22zp.wl%tiwai@suse.de>
 <20140214144524.GK5018@intel.com>
 <s5hy51dzr9f.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hy51dzr9f.wl%tiwai@suse.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 03:46:20PM +0100, Takashi Iwai wrote:
> The acpi_osi blacklist is just a workaround, and if we have better
> solutions, it should be removed.  That's why I'm asking it.
> 
> So, after removing acpi_osi blacklist, and keeping your video
> blacklist patch, the backlight works?

Yes, the backlight works (there is only intel_backlight listed under
/sys/class/backlight).

> If yes, as mentioned, we should think of rather extending this video
> blacklist to more EliteBook G1 and ProBook G1 machines, and remove
> acpi_osi blacklist instead.

Makes sense to me. (Well, I'm fine as long as backlight on my machine works
;-))

Aaron, Rafael, any comments on this?
