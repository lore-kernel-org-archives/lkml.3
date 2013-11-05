Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab3KENMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:12:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60373 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3KENMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:12:34 -0500
Date: Tue, 5 Nov 2013 14:12:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Luciano Coelho <luca@coelho.fi>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        "John W. Linville" <linville@tuxdriver.com>,
        Felipe Balbi <balbi@ti.com>, Sachin Kamat <sachin.kamat@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] wl1251: spi: add vio regulator support
Message-ID: <20131105131232.GD30670@amd.pavel.ucw.cz>
References: <1382890469-25286-1-git-send-email-sre@debian.org>
 <1382890469-25286-4-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382890469-25286-4-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2013-10-27 17:14:28, Sebastian Reichel wrote:
> This patch adds support for requesting the regulator powering
> the vio pin.
> 
> The patch also adds the regulator for the all boards using the
> wl1251 in spi mode (only the Nokia N900).
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>

Reviewed-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
