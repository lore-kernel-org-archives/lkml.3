Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3H1Bem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 21:34:42 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:56374 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab3H1Bel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 21:34:41 -0400
Date: Tue, 27 Aug 2013 18:29:58 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, notasas@gmail.com
Subject: Re: [PATCH] power: twl4030-charger: Fix compiler warning with
 regulator_enable()
Message-ID: <20130828012958.GE10506@lizard>
References: <1377073897-5165-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377073897-5165-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 11:31:37AM +0300, Peter Ujfalusi wrote:
> The return value of regulator_enable need to be checked. This patch fixes
> the following warning:
> drivers/power/twl4030_charger.c: In function ‘twl4030_charger_enable_usb’:
> drivers/power/twl4030_charger.c:192:20: warning: ignoring return value of ‘regulator_enable’, declared with attribute warn_unused_result [-Wunused-result]
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Applied, thanks a lot!

Anton
