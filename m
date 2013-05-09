Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3EIUaC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:30:02 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58277 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab3EIUaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:30:00 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 9 May 2013 13:30:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 0/3] pm: Introduce __pm to mark power management code
Message-ID: <20130509203007.GA31769@roeck-us.net>
References: <1368119366-8716-1-git-send-email-linux@roeck-us.net>
 <1728768.gTkBc2iT1V@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1728768.gTkBc2iT1V@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 09:15:00PM +0200, Rafael J. Wysocki wrote:
> On Thursday, May 09, 2013 10:09:23 AM Guenter Roeck wrote:
> > The following patch series introduces a marker for power management functions
> > and data. This this marker, #ifdef CONFIG_PM and #ifdef CONFIG_PM_SLEEP
> > can be removed from most of the code. This ensures that the conditional code
> > still compiles but is not included in the object file.
> > 
> > As a side effect, drivers declaring struct dev_pm_ops unconditionally
> > get a bit smaller if CONFIG_PM_SLEEP is not configured.
> > 
> > The first patch in the series introduces the marker, the following
> > two patches introduce the marker in two drivers to demonstrate its use.
> > 
> > The patch series depends on the "PM: Add pm_ops_ptr() macro" patch
> > submitted by Jingoo Han.
> 
> What about CCing a PM core maintainer?
> 
Actually, that was the idea. Somehow my send script got screwed up.
No idea what happened. Sorry for that.

Guenter
