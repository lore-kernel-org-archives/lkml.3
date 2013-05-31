Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab3EaRle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:41:34 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:59262 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3EaRl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:41:26 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Hebbar Gururaja <gururaja.hebbar@ti.com>
Cc: <akpm@linux-foundation.org>, <linux@arm.linux.org.uk>, <zonque@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <a.zummo@towertech.it>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <vaibhav.bedia@ti.com>, <sudhakar.raj@ti.com>
Subject: Re: [PATCH 2/2] rtc: omap: add rtc wakeup support to alarm events
References: <1369982005-8572-1-git-send-email-gururaja.hebbar@ti.com>
	<1369982005-8572-3-git-send-email-gururaja.hebbar@ti.com>
Date: Fri, 31 May 2013 10:41:22 -0700
In-Reply-To: <1369982005-8572-3-git-send-email-gururaja.hebbar@ti.com> (Hebbar
	Gururaja's message of "Fri, 31 May 2013 12:03:25 +0530")
Message-ID: <87a9nb2gjh.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hebbar Gururaja <gururaja.hebbar@ti.com> writes:

> On some platforms (like AM33xx), a special register (RTC_IRQWAKEEN)
> is available to enable Wakeup feature for Alarm Events.
>
> Since new platforms/Boards are now added through DT only, this feature
> is supported via DT property only.

> Platforms using such IP should add the property "ti,has_irq_wake_enb"
> in rtc DT node.

This is a property of the IP, not the board.  Can't you detect this
based on the revision of the IP?

Kevin
