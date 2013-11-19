Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab3KSNKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:10:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56780 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3KSNKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:10:11 -0500
Date: Tue, 19 Nov 2013 14:10:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, freemangordon@abv.bg, aaro.koskinen@iki.fi,
        Jenny TC <jenny.tc@intel.com>
Subject: Re: [PATCH v2 1/3] power_supply: Add power_supply notifier
Message-ID: <20131119131006.GD14587@amd.pavel.ucw.cz>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-2-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384856285-19593-2-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2013-11-19 11:18:03, Pali Rohár wrote:
> This patch adds a notifier chain to the power_supply.
> This notifier helps drivers in other subsystem to listen to
> changes in power supply subsystem. This would help to take some
> actions in those drivers on changing the power supply properties.
> One such scenario is to increase/decrease system performance based
> on the battery capacity/voltage. Another scenario is to adjust the
> h/w peak current detection voltage/current thresholds based on battery
> voltage/capacity. The notifier helps drivers to listen to changes
> in power_suppy susbystem without polling the power_supply properties
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

Reviewed-by: Pavel Machek <pavel@ucw.cz>

> +extern struct atomic_notifier_head    power_supply_notifier;

You may want to delete some spaces here.

Thanks,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
