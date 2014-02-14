Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaBNWHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 17:07:13 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56368 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752893AbaBNWHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 17:07:11 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "ACPI / video: Add HP EliteBook Revolve 810 to the blacklist"
Date: Fri, 14 Feb 2014 23:21:53 +0100
Message-ID: <5716481.SxKZLEy9L1@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140214152601.GL5018@intel.com>
References: <1392381247-28109-1-git-send-email-mika.westerberg@linux.intel.com> <s5hy51dzr9f.wl%tiwai@suse.de> <20140214152601.GL5018@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 14, 2014 05:26:01 PM Mika Westerberg wrote:
> On Fri, Feb 14, 2014 at 03:46:20PM +0100, Takashi Iwai wrote:
> > The acpi_osi blacklist is just a workaround, and if we have better
> > solutions, it should be removed.  That's why I'm asking it.
> > 
> > So, after removing acpi_osi blacklist, and keeping your video
> > blacklist patch, the backlight works?
> 
> Yes, the backlight works (there is only intel_backlight listed under
> /sys/class/backlight).
> 
> > If yes, as mentioned, we should think of rather extending this video
> > blacklist to more EliteBook G1 and ProBook G1 machines, and remove
> > acpi_osi blacklist instead.
> 
> Makes sense to me. (Well, I'm fine as long as backlight on my machine works
> ;-))
> 
> Aaron, Rafael, any comments on this?

I generally agree with Takashi, but I'm not sure what to do for 3.14.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
