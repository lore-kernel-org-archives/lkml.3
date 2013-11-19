Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3KSNTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:19:30 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:47408 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3KSNT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:19:28 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 1/3] power_supply: Add power_supply notifier
Date: Tue, 19 Nov 2013 14:19:19 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.2; x86_64; ; )
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, freemangordon@abv.bg, aaro.koskinen@iki.fi,
        Jenny TC <jenny.tc@intel.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com> <1384856285-19593-2-git-send-email-pali.rohar@gmail.com> <20131119131006.GD14587@amd.pavel.ucw.cz>
In-Reply-To: <20131119131006.GD14587@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201311191419.25036@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 November 2013 14:10:06 Pavel Machek wrote:
> On Tue 2013-11-19 11:18:03, Pali Rohár wrote:
> > This patch adds a notifier chain to the power_supply.
> > This notifier helps drivers in other subsystem to listen to
> > changes in power supply subsystem. This would help to take
> > some actions in those drivers on changing the power supply
> > properties. One such scenario is to increase/decrease
> > system performance based on the battery capacity/voltage.
> > Another scenario is to adjust the h/w peak current
> > detection voltage/current thresholds based on battery
> > voltage/capacity. The notifier helps drivers to listen to
> > changes in power_suppy susbystem without polling the
> > power_supply properties
> > 
> > Signed-off-by: Jenny TC <jenny.tc@intel.com>
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> 
> Reviewed-by: Pavel Machek <pavel@ucw.cz>
> 
> > +extern struct atomic_notifier_head   
> > power_supply_notifier;
> 
> You may want to delete some spaces here.
> 
> Thanks,
> 								Pavel

Ok, note that this patch I copied from: 
https://lkml.org/lkml/2013/9/23/181

-- 
Pali Rohár
pali.rohar@gmail.com
