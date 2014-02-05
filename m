Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbaBEIPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:15:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:44847 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbaBEIPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:15:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,785,1384329600"; 
   d="scan'208";a="338905641"
Date: Wed, 5 Feb 2014 13:44:58 +0530
From: Jenny Tc <jenny.tc@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, aaro.koskinen@iki.fi,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        freemangordon@abv.bg, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/4] power_supply: Introduce generic psy charging driver
Message-ID: <20140205081458.GA19586@jenny-desktop>
References: <1391490780-6141-1-git-send-email-jenny.tc@intel.com>
 <1391490780-6141-3-git-send-email-jenny.tc@intel.com>
 <20140204113630.GC2450@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204113630.GC2450@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 12:36:30PM +0100, Pavel Machek wrote:
> > +struct psy_charger_context {
> > +	bool is_usb_cable_evt_reg;
> > +	int psyc_cnt;
> > +	int batt_status;
> > +	/*cache battery and charger properties */
> 
> Comment coding style. Please run you patches through checkpatch.

checkpatch doesn't throw any error/warning. /* ... */ not allowed for single line
comments? (will fix missing space after /*)

-Jenny
