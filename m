Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3KGWLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:11:37 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:44801 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3KGWLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:11:30 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Grant Likely <grant.likely@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] of: irq: Fix interrupt-map entry matching
Date: Thu, 07 Nov 2013 23:11:28 +0100
Message-ID: <1402665.MHsL7r71dU@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAL_JsqKUaioiz2dw3Sr8f7UfqzjagWH_je2-u_QGYXRK5g1=yg@mail.gmail.com>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org> <1773667.KXPxL5WsyI@amdc1227> <CAL_JsqKUaioiz2dw3Sr8f7UfqzjagWH_je2-u_QGYXRK5g1=yg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 of November 2013 10:40:16 Rob Herring wrote:
> On Thu, Nov 7, 2013 at 5:32 AM, Tomasz Figa <t.figa@samsung.com> wrote:
> > Hi Grant,
> > 
> > Could you pick this patch up? It fixes boot-up at least on several
> > Exynos based platforms, which use interrupt-map nodes with
> > #interrupt-cells higher than 1.
> > 
> > Also please disregard patch 2/2, as your fix that has been merged
> > seems
> > to be fine.
> 
> I've applied the 1st patch.

Thanks Rob.

Best regards,
Tomasz

