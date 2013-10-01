Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3JAJHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 05:07:13 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:63686 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3JAJHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:07:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130924131039.3c871cad7acb2a068a988d0f@ops.dti.ne.jp>
References: <52410F86.4040301@renesas.com>
	<20130924131039.3c871cad7acb2a068a988d0f@ops.dti.ne.jp>
Date: Tue, 1 Oct 2013 18:07:08 +0900
Message-ID: <CANqRtoQBnPCy8xCsn37yYweKH0rpwbUupdEnBrnqH3owJ_mbjA@mail.gmail.com>
Subject: Re: [PATCH 2/6] serial8250-em: convert to clk_prepare/unprepare
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

On Tue, Sep 24, 2013 at 1:10 PM,  <takasi-y@ops.dti.ne.jp> wrote:
> From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
>
> Add calls to clk_prepare and unprepare so that EMMA Mobile EV2 can
> migrate to the common clock framework.
>
> Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> [takashi.yoshii.ze@renesas.com: edited for conflicts]
> Signed-off-by: Takashi Yoshii <takashi.yoshii.zj@renesas.com>
> ---
>  drivers/tty/serial/8250/8250_em.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

This looks fine to me, thanks!

Acked-by: Magnus Damm <damm@opensource.se>
