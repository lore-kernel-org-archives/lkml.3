Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab3BUKBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 05:01:32 -0500
Received: from sauhun.de ([89.238.76.85]:60244 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415Ab3BUKBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 05:01:30 -0500
Date: Thu, 21 Feb 2013 11:01:28 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: i2c-pxa - remove incorrect __exit annotations
Message-ID: <20130221100128.GC22806@the-dreams.de>
References: <20130220085008.GA11025@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220085008.GA11025@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 12:50:10AM -0800, Dmitry Torokhov wrote:
> The remove() methods should not be marked __exit unless we are using
> platform_driver_probe() which disables unbinding device from driver
> via sysfs.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Eeks, I broke this with my very first linux patch years ago :) Applied
to -next, thanks!

