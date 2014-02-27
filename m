Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaB0TrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:47:11 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:39409 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaB0TrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:47:08 -0500
MIME-Version: 1.0
In-Reply-To: <20140226025444.GA21449@jenny-desktop>
References: <1391490780-6141-1-git-send-email-jenny.tc@intel.com>
	<1391490780-6141-4-git-send-email-jenny.tc@intel.com>
	<20140204113640.GD2450@amd.pavel.ucw.cz>
	<20140220051655.GB2498@jenny-desktop>
	<20140221144529.GB5238@amd.pavel.ucw.cz>
	<20140226025444.GA21449@jenny-desktop>
Date: Thu, 27 Feb 2014 20:47:07 +0100
Message-ID: <CACRpkdYQuggnUU+3JrxG9oA5_CRnbfT0aVL=L3K0QPrVzZTD-w@mail.gmail.com>
Subject: Re: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
From: Linus Walleij <linus.walleij@linaro.org>
To: Jenny Tc <jenny.tc@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        =?windows-1251?B?yOLg6evuIMTo7Ojy8O7i?= <freemangordon@abv.bg>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 3:54 AM, Jenny Tc <jenny.tc@intel.com> wrote:

> The idea is to allow pluggable charging algorithms. Currently we have only one
> charging algorithm proposed, but can have other charging algorithms (like pulse
> charging, rule based charging etc.). Based on the platform need, the algorithms
> can be selected. So this should be a user configurable option. I can add more
> explanation on when to select this option.

Do you see a generic framework for pluggable algorithms on an abstracted
level, so that it could be used for the CC/CV charging, measurement and
temperature check algorithm that is found in e.g.
drivers/power/abx500_chargalg.c
drivers/power/ab8500_charger.c etc, or do you envision a set of pluggable
algorithms for this one hardware?

I'm asking because these drivers are a massive set of code and we may
need to start to abstract out and define library functions and frameworks
already now before it becomes impossible to contain.

Yours,
Linus Walleij
