Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab3JAJFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 05:05:55 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:64676 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab3JAJFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:05:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130924130924.61d4ecedf3d4fca5952d55fc@ops.dti.ne.jp>
References: <52410F86.4040301@renesas.com>
	<20130924130924.61d4ecedf3d4fca5952d55fc@ops.dti.ne.jp>
Date: Tue, 1 Oct 2013 18:05:50 +0900
Message-ID: <CANqRtoRUy=Fi3-YeMLpiCinOw+0bkVUbjUMYUo7Lv85+b8=UPg@mail.gmail.com>
Subject: Re: [PATCH 1/6] clocksource: em_sti: convert to clk_prepare/unprepare
From: Magnus Damm <magnus.damm@gmail.com>
To: takasi-y@ops.dti.ne.jp
Cc: SH-Linux <linux-sh@vger.kernel.org>, Ben Dooks <ben.dooks@codethink.co.uk>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 1:09 PM,  <takasi-y@ops.dti.ne.jp> wrote:
> From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
>
> Add calls to clk_prepare and unprepare so that EMMA Mobile EV2 can
> migrate to the common clock framework.
>
> Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> ---
>  drivers/clocksource/em_sti.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Looking good, thanks!

Acked-by: Magnus Damm <damm@opensource.se>
