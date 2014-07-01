Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbaGAMxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:53:43 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:49114 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaGAMxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:53:41 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.36.201]
In-Reply-To: <1398904476-26200-8-git-send-email-s-anna@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com> <1398904476-26200-8-git-send-email-s-anna@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 1 Jul 2014 15:53:19 +0300
Message-ID: <CAK=WgbaVzfWLXiX0y9K=-FAG98ywbWojtyyoEket-q5e5pdufA@mail.gmail.com>
Subject: Re: [PATCHv5 07/15] hwspinlock/omap: enable build for AM33xx, AM43xx
 & DRA7xx
To: Suman Anna <s-anna@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Thu, May 1, 2014 at 3:34 AM, Suman Anna <s-anna@ti.com> wrote:
> HwSpinlocks are supported on AM33xx, AM43xx and DRA7xx SoC
> device families as well. The IPs are identical to that of
> OMAP4/OMAP5, except for the number of locks.
>
> Add a depends on to the above family of SoCs to enable the
> build support for OMAP hwspinlock driver for any of the above
> SoC configs.
>
> Signed-off-by: Suman Anna <s-anna@ti.com>

This looks too like an independent change. If you want it merged
without waiting for the entire series please submit it separately.

Thanks,
Ohad.
