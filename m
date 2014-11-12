Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaKLPRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:17:07 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:44905 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbaKLPRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:17:05 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.100.67]
In-Reply-To: <1410553499-55951-3-git-send-email-s-anna@ti.com>
References: <1410553499-55951-1-git-send-email-s-anna@ti.com> <1410553499-55951-3-git-send-email-s-anna@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 12 Nov 2014 17:16:37 +0200
Message-ID: <CAK=Wgba2hS6jwZ0+-YVPjjg2M9rTSccWmUEKYF_RMPoq14cxaw@mail.gmail.com>
Subject: Re: [PATCHv6 2/5] Documentation: dt: add the omap hwspinlock bindings document
To: Suman Anna <s-anna@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Fri, Sep 12, 2014 at 11:24 PM, Suman Anna <s-anna@ti.com> wrote:
> HwSpinlock IP is present only on OMAP4 and other newer SoCs,
> which are all device-tree boot only. This patch adds the
> DT bindings information for OMAP hwspinlock module.
>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Suman Anna <s-anna@ti.com>
> ---
>  .../devicetree/bindings/hwlock/omap-hwspinlock.txt | 24 ++++++++++++++++++++++

I need an ACK from a DT maintainer here as well, please try to get it.

Thanks,
Ohad.
