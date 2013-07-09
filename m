Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab3GITA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 15:00:57 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:54204 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752528Ab3GITAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 15:00:55 -0400
Date: Tue, 9 Jul 2013 21:00:52 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] watchdog: softdog: remove replaceable ping operation
Message-ID: <20130709190052.GA20296@spo001.leaseweb.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E49607@DQHE02.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E49607@DQHE02.ent.ti.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Milo,

> In watchdog_ping(), 'start' is called automatically when 'ping' function call
> is not configured.
> Softdog driver has same handling in both cases - start and ping, so 'ping' OPS
> can be removed.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/watchdog/softdog.c |    1 -
>  1 file changed, 1 deletion(-)

Patch added to linux-watchdog-next.

Kind regards,
Wim.

