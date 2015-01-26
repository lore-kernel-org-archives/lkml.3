Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbbAZUuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:50:21 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:48248 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324AbbAZUuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:50:07 -0500
MIME-Version: 1.0
In-Reply-To: <20150124003009.GA14891@dtor-ws>
References: <20150124003009.GA14891@dtor-ws>
Date: Mon, 26 Jan 2015 12:50:06 -0800
X-Google-Sender-Auth: rvn7_MbpVxEEzJ22Y66odH9t7LQ
Message-ID: <CAD=FV=XpQ41VgjWTmuByTSo0Oa2Z0tm2eeNYFpSFLdufUrpOPw@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: rockchip: remove incorrect __exit_p()
From: Doug Anderson <dianders@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Heiko Stuebner <heiko@sntech.de>,
        Chris Ball <chris@printf.net>, Addy Ke <addy.ke@rock-chips.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

On Fri, Jan 23, 2015 at 4:30 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> dw_mci_pltfm_remove() is not (nor should it be) marked as __exit,
> so we should not be using __exit_p() wrapper with it.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/mmc/host/dw_mmc-rockchip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Nice catch, thanks!

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
