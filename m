Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3AWPEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:04:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:43372 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab3AWPEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:04:04 -0500
Date: Wed, 23 Jan 2013 07:05:32 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V5] drivers/pinctrl: grab default handles from device core
Message-ID: <20130123150532.GA2383@kroah.com>
References: <1358877374-1279-1-git-send-email-swarren@wwwdotorg.org>
 <CACRpkdZTwvdmRnDOAcOObj7NhkuUunACpYBvAE1bY65suroQiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZTwvdmRnDOAcOObj7NhkuUunACpYBvAE1bY65suroQiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 09:50:36AM +0100, Linus Walleij wrote:
> OK!
> 
> This modified version of the patch is way more beautiful, stupid
> me for not realizing it could be written like that.
> 
> And I can sure live with the removed doc piece ... we can discuss
> that separately if need be, I have some argument for it but it's
> a separate issue.
> 
> I've dubbed this version the v5 variant and applied it, and included
> the changelog (so I remember how it came about).
> 
> Greg/Mark: are you still confident with your ACK/Reviewed-by
> tags being added on this version?

Yes, that's fine with me.
