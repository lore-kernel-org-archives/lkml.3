Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbaHAUhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:37:18 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:63909 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaHAUhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:37:15 -0400
MIME-Version: 1.0
In-Reply-To: <1406868897-26874-7-git-send-email-afaerber@suse.de>
References: <1406868897-26874-1-git-send-email-afaerber@suse.de>
	<1406868897-26874-7-git-send-email-afaerber@suse.de>
Date: Fri, 1 Aug 2014 13:37:13 -0700
X-Google-Sender-Auth: -GOAPgTgWh-B81Mfl0PIMmd2xqM
Message-ID: <CAD=FV=Vra6p3bUeHGz6hTXjM1QMCZ-Ph++oqMWFAj1Uqmdg1rw@mail.gmail.com>
Subject: Re: [PATCH v5 06/10] ARM: dts: Clean up exynos5250-smdk5250
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Thu, Jul 31, 2014 at 9:54 PM, Andreas Färber <afaerber@suse.de> wrote:
> Use the new style for referencing inherited nodes and use symbolic names.
>
> Goal is the alignment of all exynos5250 based device trees for comparison.
>
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v5: New
>  Follow-up after adding dp_hpd pinctrl node new-style.

Since I NAKed that one, are you going to drop this patch?  It's
probably still a useful thing to do.

It sounds like you might be spinning?  ...if so I'll review it in the
next cycle...  Note: same feedback as before about splitting changes
to exynos5250.dtsi and actual board files...

-Doug
