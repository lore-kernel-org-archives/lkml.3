Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab3F0Tbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 15:31:40 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:52689 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753796Ab3F0Tbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:31:39 -0400
Date: Thu, 27 Jun 2013 21:31:38 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: anish kumar <anish198519851985@gmail.com>
Cc: linux@roeck-us.net, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC]Watchdog:core: constant pinging until userspace timesout when delay very less
Message-ID: <20130627193138.GB30433@spo001.leaseweb.com>
References: <1370167987-14252-1-git-send-email-anish198519851985@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370167987-14252-1-git-send-email-anish198519851985@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anish,

> Certain watchdog drivers use a timer to keep kicking the watchdog at
> a rate of 0.5s (HZ/2) untill userspace times out.They do this as
> we can't guarantee that watchdog will be pinged fast enough
> for all system loads, especially if timeout is configured for
> less than or equal to 1 second(basically small values).
> 
> As suggested by Wim Van Sebroeck & Guenter Roeck we should
> add this functionality of individual watchdog drivers in the core
> watchdog core.

Have you considered the effect this change has on all watchdog drivers
that don't need a timer?

Kind regards,
Wim.

