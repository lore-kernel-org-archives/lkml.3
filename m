Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaHAQ0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:26:51 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:59742 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaHAQ0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:26:49 -0400
MIME-Version: 1.0
In-Reply-To: <1406868897-26874-2-git-send-email-afaerber@suse.de>
References: <1406868897-26874-1-git-send-email-afaerber@suse.de>
	<1406868897-26874-2-git-send-email-afaerber@suse.de>
Date: Fri, 1 Aug 2014 09:26:48 -0700
X-Google-Sender-Auth: l4CEYh9EoGqLkKDp6SKjD8Au0IU
Message-ID: <CAD=FV=VBa5rs_woj0mshFFbA69Nhyi3hXK_XX7-54T3vFyKYHA@mail.gmail.com>
Subject: Re: [PATCH v5 01/10] ARM: dts: Fix MMC pinctrl for exynos5250-snow
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 31, 2014 at 9:54 PM, Andreas Färber <afaerber@suse.de> wrote:
> The pinctrl properties should be on the device directly and not on the
> slot sub-node.
>
> Reported-by: Doug Anderson <dianders@chromium.org>
> Cc: Jaehoon Chung <jh80.chung@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Andreas Färber <afaerber@suse.de>

Let's land this one before Jaehoon's, since it was a hidden
functionality change in his patch.  It will be an easy conflict to
resolve when his patch is applied.

Reviewed-by: Doug Anderson <dianders@chromium.org>
