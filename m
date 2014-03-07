Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaCGDnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:43:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:51548 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaCGDnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:43:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,605,1389772800"; 
   d="scan'208";a="495599030"
Date: Fri, 7 Mar 2014 09:13:06 +0530
From: Jenny Tc <jenny.tc@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
Message-ID: <20140307034305.GA19526@jenny-desktop>
References: <1391490780-6141-1-git-send-email-jenny.tc@intel.com>
 <1391490780-6141-4-git-send-email-jenny.tc@intel.com>
 <CACRpkdbppewuSSJu=Y=1T7oOCxz_ynhNspyPT=S894KoUB6H6g@mail.gmail.com>
 <20140228030727.GB27921@jenny-desktop>
 <CACRpkdanZ2NiwAkd2nTXQ1=bqqmatbGXxK8t9TGSYfjG8cvJZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdanZ2NiwAkd2nTXQ1=bqqmatbGXxK8t9TGSYfjG8cvJZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 11:34:14AM +0800, Linus Walleij wrote:
> On Fri, Feb 28, 2014 at 11:07 AM, Jenny Tc <jenny.tc@intel.com> wrote:
> > On Thu, Feb 27, 2014 at 09:18:57PM +0100, Linus Walleij wrote:
> >> On Tue, Feb 4, 2014 at 6:12 AM, Jenny TC <jenny.tc@intel.com> wrote:
> >>
> >> > +static inline bool __is_battery_full
> >> > +       (long volt, long cur, long iterm, unsigned long cv)
> >>
> >> Overall I wonder if you've run checkpatch on these patches, but why
> >> are you naming this one function with a double __underscore?
> >> Just is_battery_full_check() or something would work fine I guess?
> >
> > Just to convey that is_battery_full is a local function and not generic. You
> > can find similar usage in power_supply_core.c (__power_supply_changed_work)
> > and in other drivers. Isn't it advised to have __ prefixes?
> 
> The preference is different, usually __ is for compiler things, but
> while I dislike it (disturbs my perception) I can sure live with it.

Fixed in patch set v7
