Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3IPGdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 02:33:10 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:34088 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab3IPGdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 02:33:08 -0400
Date: Sun, 15 Sep 2013 19:25:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: rydberg@euromail.se
Cc: Nick Dyer <nick.dyer@itdev.co.uk>, Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 20/51] Input: atmel_mxt_ts - Set default irqflags when
 there is no pdata
Message-ID: <20130916022533.GA6468@core.coreip.homeip.net>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
 <1372337366-9286-21-git-send-email-nick.dyer@itdev.co.uk>
 <20130718171744.GC32381@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718171744.GC32381@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 07:17:44PM +0200, rydberg@euromail.se wrote:
> Hi Nick,
> 
> > From: Yufeng Shen <miletus@chromium.org>
> > 
> > This is the preparation for supporting the code path when there is
> > platform data provided and still boot the device into a sane state
> > with backup NVRAM config.
> > 
> > Make the irqflags default to be IRQF_TRIGGER_FALLING if no platform data is
> > provided.

I think if there is no platform data we should use 0 as IRQ falgs and
assume that IRQ line is properly configured by the board code or via
device tree.

Thanks.

-- 
Dmitry
