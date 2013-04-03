Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab3DCOMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:12:20 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:42081 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758088Ab3DCOMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:12:19 -0400
Date: Wed, 3 Apr 2013 16:12:08 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/3] check regulator_enable() return value
Message-ID: <20130403141208.GA21766@balto.lan>
References: <1364997747-20830-1-git-send-email-fabio.baltieri@linaro.org>
 <20130403140622.GI14680@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403140622.GI14680@arwen.pp.htv.fi>
X-Operating-System: Linux balto 3.9.0-rc4-00218-g0776ce0 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Wed, Apr 03, 2013 at 05:06:22PM +0300, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Apr 03, 2013 at 04:02:24PM +0200, Fabio Baltieri wrote:
> > While testing your 'next' branch merged with today's next I got some new
> > warnings, caused by a recently introduced __must_check in:
> > 
> > c8801a8 regulator: core: Mark all get and enable calls as __must_check
> > 
> > These patches introduces a check for regulator_enable() return value in
> > all three affected USB phy drivers, and issue a dev_err() in case it
> > fails.
> > 
> > TWL4030 and TWL6030 patches has been build-tested only.
> 
> Sorry but I can't change my tree anymore, we can send these during
> v3.10-rc.

Sure, I've no problem with that!

Thanks,
Fabio

-- 
Fabio Baltieri
