Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab3JAQPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:15:06 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:46444 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3JAQPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:15:03 -0400
Date: Tue, 1 Oct 2013 09:14:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: =?utf-8?q?Heiko_St=C3=BCbner_=3Cheiko=40sntech=2Ede=3E?=@roeck-us.net
Cc: Wim Van Sebroeck <wim@iguana.be>, Jamie Iles <jamie@jamieiles.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [2/3] watchdog: dw_wdt: use clk_prepare_enable and
 clk_disable_unprepare
Message-ID: <20131001161455.GA10237@roeck-us.net>
References: <201306262004.31808.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306262004.31808.heiko@sntech.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 02:04:31AM -0000, =?utf-8?q?Heiko_St=C3=BCbner_=3Cheiko=40sntech=2Ede=3E?= wrote:
> This is necessary to make the driver work with platforms using the
> common clock framework.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> 
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
