Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbbAPUNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 15:13:16 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:37261 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbbAPUNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 15:13:15 -0500
MIME-Version: 1.0
In-Reply-To: <1421315385-79209-1-git-send-email-xiakaixu@huawei.com>
References: <1421315385-79209-1-git-send-email-xiakaixu@huawei.com>
Date: Fri, 16 Jan 2015 13:13:14 -0700
Message-ID: <CANLsYkwxny2_YiPrDOJ1OYeUYqSB5gc3rSe9LHvjMmTNrz9RDg@mail.gmail.com>
Subject: Re: [PATCH] coresight: fix the debug AMBA bus name
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Kaixu Xia <xiakaixu@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kaixu Xia <kaixu.xia@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 January 2015 at 02:49, Kaixu Xia <xiakaixu@huawei.com> wrote:
> The right debug AMBA bus name should be APB(Advanced Peripheral Bus),
> so just fix it.
>
> Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
> ---
>  Documentation/trace/coresight.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/trace/coresight.txt b/Documentation/trace/coresight.txt
> index bba7dbf..0236155 100644
> --- a/Documentation/trace/coresight.txt
> +++ b/Documentation/trace/coresight.txt
> @@ -46,7 +46,7 @@ At typical coresight system would look like this:
>    | |   .        | !   | |   .        | !      | !        .   |      | SWD/
>    | |   .        | !   | |   .        | !      | !        .   |      | JTAG
>    *****************************************************************<-|
> - *************************** AMBA Debug ABP ************************
> + *************************** AMBA Debug APB ************************
>    *****************************************************************
>     |    .          !         .          !        !        .    |
>     |    .          *         .          *        *        .    |
> @@ -79,7 +79,7 @@ At typical coresight system would look like this:
>            To trace port                       TPIU= Trace Port Interface Unit
>                                                SWD = Serial Wire Debug
>
> -While on target configuration of the components is done via the ABP bus,
> +While on target configuration of the components is done via the APB bus,
>  all trace data are carried out-of-band on the ATB bus.  The CTM provides
>  a way to aggregate and distribute signals between CoreSight components.
>
> --
> 1.8.5.5
>

Apply - thanks.
