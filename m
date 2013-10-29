Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3J2M7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 08:59:05 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:39441 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755082Ab3J2M7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:59:03 -0400
Date: Tue, 29 Oct 2013 13:58:48 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: boris brezillon <b.brezillon@overkiz.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Guenter Roeck <groeck7@gmail.com>, Yang Wenyou <wenyou.yang@atmel.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v5 0/4] watchdog: at91sam9_wdt: handle already configured wdt
Message-ID: <20131029125848.GB5261@spo001.leaseweb.com>
References: <1380871455-7324-1-git-send-email-b.brezillon@overkiz.com> <20131029075028.GF19704@spo001.leaseweb.com> <526F8E89.30005@overkiz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526F8E89.30005@overkiz.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

> I'm sorry for the inconvenience, but I found some bugs in my patch series:
> 
> 1) the secs_to_ticks returns an erronous value when 0 is passed as an 
> argument
> 2) the calculated heartbeat is too small for some use cases
>     (i.e. kexecing a new kernel might trigger a watchdog reset before 
> the new kernel
>      is able to load the watchdog driver)
> 3) when initializing the watchdog driver, the timer should be configured 
> with the min_heartbeat value
>     instead of the standard heartbeat value, because we don't for how 
> long the timer has been running.
> 
> I'll send a new patch fixing those issues.
> I hope it won't bother you :-(.

No problem :-). Just sent me the fixes when they are ready.

Kind regards,
Wim.

