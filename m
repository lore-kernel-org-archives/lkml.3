Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab3FESFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 14:05:30 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:65126 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab3FESF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 14:05:27 -0400
MIME-Version: 1.0
In-Reply-To: <1366101013-21183-2-git-send-email-peter.ujfalusi@ti.com>
References: <1366101013-21183-1-git-send-email-peter.ujfalusi@ti.com>
	<1366101013-21183-2-git-send-email-peter.ujfalusi@ti.com>
Date: Wed, 5 Jun 2013 11:05:26 -0700
Message-ID: <CAGa+x86FjN7-CMi2iSxrqyEKG+rBSPtfAOntjYftGUvToyn75g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] RTC: rtc-twl: Cleanup with module_platform_driver()
 conversion
From: Kevin Hilman <khilman@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 1:30 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Use module_platform_driver() to register the platform driver.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Acked-by: Kevin Hilman <khilman@linaro.org>
