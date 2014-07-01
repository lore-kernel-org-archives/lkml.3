Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbaGAMvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:51:51 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:39432 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247AbaGAMvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:51:49 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.36.201]
In-Reply-To: <1398904476-26200-7-git-send-email-s-anna@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com> <1398904476-26200-7-git-send-email-s-anna@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 1 Jul 2014 15:51:27 +0300
Message-ID: <CAK=WgbaKPgLLw-4wCSToE86QrREDB0sK95TLx2y17d71eBPFbg@mail.gmail.com>
Subject: Re: [PATCHv5 06/15] hwspinlock/omap: enable module before reading
 SYSSTATUS register
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
> The number of hwspinlocks are determined based on the value read
> from the IP block's SYSSTATUS register. However, the module may
> not be enabled and clocked, and the read may result in a bus error.
>
> This particular issue is seen rather easily on AM33XX, since the
> module wakeup is software controlled, and it is disabled out of
> reset. Make sure the module is enabled and clocked before reading
> the SYSSTATUS register.

This seems like a valid fix that is independent of this patch series.

Feel free to submit it separately if you want, so we can get it merged.

Thanks,
Ohad.
