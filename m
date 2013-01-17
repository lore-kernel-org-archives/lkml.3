Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3AQM5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:57:15 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:43611 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3AQM5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:57:13 -0500
Date: Thu, 17 Jan 2013 13:57:02 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Subject: Re: [PATCH] usb: musb: ux500: use clk_prepare_enable and
 clk_disable_unprepare
Message-ID: <20130117125702.GA5007@balto.lan>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@linaro.org>,
	Felipe Balbi <balbi@ti.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>, linux-usb@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
References: <1357577261-31536-1-git-send-email-fabio.baltieri@linaro.org>
 <CACRpkdZD1i_tvDf6XFyk5muYjtDziQaMNGK6vvihhFJVztXUjw@mail.gmail.com>
 <20130110133818.GA22710@balto.lan>
 <CACRpkdbmgQ0xDfkbgqc=zDqMDUK0O6uQOf3kX9v1+=+N5s42bw@mail.gmail.com>
 <20130117105104.GN10814@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130117105104.GN10814@arwen.pp.htv.fi>
X-Operating-System: Linux balto 3.8.0-rc3-00293-g406089d x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 12:51:04PM +0200, Felipe Balbi wrote:
> > > Thanks for the ACK.  This bug was here unnoticed since 3.6 merge window,
> > 
> > Then it should have Cc: stable@kernel.org..
> 
> just added to my tree.

Hi Felipe, thanks for adding the stable tag to the patch, but I actually
made a bit of confusion with the versions, so I double checked and it
turns out this is really needed on v3.7 stable, not v3.6.

Will you be so kind to remove v3.6 from the stable tag from this
patch?

Thanks and sorry for the added noise!
Fabio

-- 
Fabio Baltieri
