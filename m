Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946339Ab3BHLgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 06:36:31 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:34255 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946284Ab3BHLg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 06:36:28 -0500
Date: Fri, 8 Feb 2013 12:36:26 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: linux-next: manual merge of the watchdog tree with the mfd tree
Message-ID: <20130208113626.GV7867@spo001.leaseweb.com>
References: <20130208125220.37a34d89ea4cc7e43b27cf4e@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208125220.37a34d89ea4cc7e43b27cf4e@canb.auug.org.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> Today's linux-next merge of the watchdog tree got conflicts in
> drivers/watchdog/Kconfig and drivers/watchdog/Makefile between commit
> 699ff59052e7 ("watchdog: Add support for ux500_wdt watchdog") from the
> mfd tree and commit 77b709cb6c9d ("watchdog: introduce retu_wdt driver")
> from the watchdog tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks!

Kind regards,
Wim.

