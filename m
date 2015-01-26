Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbbAZUte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:49:34 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34997 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbbAZUt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:49:29 -0500
MIME-Version: 1.0
In-Reply-To: <20150124003340.GA16286@dtor-ws>
References: <20150124003340.GA16286@dtor-ws>
Date: Mon, 26 Jan 2015 12:49:28 -0800
X-Google-Sender-Auth: yIeSmlDmt9Jp0aGTGXkQeSI6CUI
Message-ID: <CAD=FV=XWz1EktXSX_emtKpEhJKdseeuvgg4yTwaCVHBZ_sDfSg@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: exynos: remove incorrect __exit_p()
From: Doug Anderson <dianders@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Kukjin Kim <kgene@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Beomho Seo <beomho.seo@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

On Fri, Jan 23, 2015 at 4:33 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> dw_mci_pltfm_remove() is not (nor should it be) marked as __exit,
> so we should not be using __exit_p() wrapper with it.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/mmc/host/dw_mmc-exynos.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Nice catch, thanks!

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
