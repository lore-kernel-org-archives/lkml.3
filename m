Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaGNNFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:05:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34739 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbaGNNFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:05:17 -0400
Date: Mon, 14 Jul 2014 15:05:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH 1/4] power_supply: Add inlmt,iterm, min/max temp props
Message-ID: <20140714130516.GB18934@amd.pavel.ucw.cz>
References: <1404799461-26345-1-git-send-email-jenny.tc@intel.com>
 <1404799461-26345-2-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404799461-26345-2-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-07-08 11:34:18, Jenny TC wrote:
> Add new power supply properties for input current, charge termination
> current, min and max temperature
> 
> POWER_SUPPLY_PROP_TEMP_MIN - minimum operatable temperature
> POWER_SUPPLY_PROP_TEMP_MAX - maximum operatable temperature
> 
> POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT - input current limit programmed
> by charger. Indicates the input current for a charging source.
> 
> POWER_SUPPLY_PROP_CHARGE_TERM_CURRENT - Charge termination current used
> to detect the end of charge condition
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
