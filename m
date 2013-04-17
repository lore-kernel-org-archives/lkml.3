Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936252Ab3DQCGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 22:06:24 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62431 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936154Ab3DQCGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 22:06:23 -0400
Date: Tue, 16 Apr 2013 19:02:19 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: David Woodhouse <dwmw2@infradead.org>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pm2301-charger: Fix suspend/resume
Message-ID: <20130417020219.GA357@lizard.mcd26095.sjc.wayport.net>
References: <1365852007-23369-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1365852007-23369-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 01:20:07PM +0200, Lars-Peter Clausen wrote:
> The pm2301-charger driver implements runtime pm and at the same time uses the
> legacy pm callbacks for suspend and resume. This does not work since the I2C
> core wont look at the legacy pm callbacks if a driver has the 'pm' field set.
> This patch fixes it by moving over to dev_pm_ops for suspend/resume as well.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---

Applied, thanks a lot!

Anton
