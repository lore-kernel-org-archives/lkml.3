Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3EULVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 07:21:30 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58852 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3EULV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 07:21:28 -0400
MIME-Version: 1.0
In-Reply-To: <1368765198-25550-1-git-send-email-dianders@chromium.org>
References: <1368746388-20194-1-git-send-email-dianders@chromium.org>
	<1368765198-25550-1-git-send-email-dianders@chromium.org>
Date: Tue, 21 May 2013 13:21:27 +0200
Message-ID: <CACRpkdZaTH+LTR_CLiBBFnfBs_6Wuah5O4wzKqwMOYukFrRmEQ@mail.gmail.com>
Subject: Re: [PATCH v3] pinctrl: samsung: fix suspend/resume functionality
From: Linus Walleij <linus.walleij@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Prathyush K <prathyush.k@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 6:33 AM, Doug Anderson <dianders@chromium.org> wrote:

> The GPIO states need to be restored after s2r and this is not currently
> supported in the pinctrl driver. This patch saves the gpio states before
> suspend and restores them after resume.
>
> Saving and restoring is done very early using syscore_ops and must
> happen before pins are released from their powerdown state.
>
> Patch originally from Prathyush K <prathyush.k@samsung.com> but
> rewritten by Doug Anderson <dianders@chromium.org>.
>
> Signed-off-by: Prathyush K <prathyush.k@samsung.com>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v3:

Applied to my fixes branch for v3.10 with some collected
Tested-bys/Acks.

Yours,
Linus Walleij
