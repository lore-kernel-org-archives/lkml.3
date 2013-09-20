Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab3ITQTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:19:06 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:57414 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab3ITQTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:19:03 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1379693332-10585-1-git-send-email-nm@ti.com>
References: <1379693332-10585-1-git-send-email-nm@ti.com>
Date: Fri, 20 Sep 2013 09:19:02 -0700
Message-ID: <CAOesGMj6G7LeYUJsGpZHxKOjiNrk+1U55QFqcQyTb6_Co+n4zQ@mail.gmail.com>
Subject: Re: [RFC PATCH] ARM: OMAP3630: Add generic machine descriptor
From: Olof Johansson <olof@lixom.net>
To: Nishanth Menon <nm@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 20, 2013 at 9:08 AM, Nishanth Menon <nm@ti.com> wrote:
> An alternative approach may be to (for all SoCs):
> 1. define every SoC entry - ti,omap3430 ti,omap3630...
> 2. have a generic omap3_init which uses "if (of_machine_is_compatible("ti,omap3630"))"
> to invoke the appropriate omap3xxx_init_early.

Yes, this would be better, but you can do add a DT_MACHINE as in this
patch but have ti,omap3630 as the dt_compat table. Then there's no
need to add runtime checks.


-Olof
