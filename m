Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab3JAQNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:13:22 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36326 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3JAQNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:13:19 -0400
Date: Tue, 1 Oct 2013 09:13:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: =?utf-8?q?Heiko_St=C3=BCbner_=3Cheiko=40sntech=2Ede=3E?=@roeck-us.net
Cc: Wim Van Sebroeck <wim@iguana.be>, Jamie Iles <jamie@jamieiles.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [1/3] watchdog: dw_wdt: convert to SIMPLE_DEV_PM_OPS
Message-ID: <20131001161313.GA14043@roeck-us.net>
References: <201306262003.53192.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306262003.53192.heiko@sntech.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 02:03:52AM -0000, =?utf-8?q?Heiko_St=C3=BCbner_=3Cheiko=40sntech=2Ede=3E?= wrote:
> The dw_wdt only provides PM_SLEEP operations, so convert the driver
> to use SIMPLE_DEV_PM_OPS instead of populating the struct manually.
> This has the added effect of simplifying the CONFIG_PM ifdefs.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> 
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
