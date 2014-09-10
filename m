Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaIJEpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:45:53 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:43205 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaIJEpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:45:51 -0400
MIME-Version: 1.0
In-Reply-To: <1408533593-32346-3-git-send-email-javier.martinez@collabora.co.uk>
References: <1408533593-32346-1-git-send-email-javier.martinez@collabora.co.uk>
	<1408533593-32346-3-git-send-email-javier.martinez@collabora.co.uk>
Date: Tue, 9 Sep 2014 21:45:50 -0700
X-Google-Sender-Auth: yNniHXUKtjMkJwu7u4_qCYqWzGU
Message-ID: <CAD=FV=XLUpguNdyWXzEvF_5u9yHMs=KWVEX_EsYZDwLkTEGM2A@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] ARM: dts: add hdmi regulators for exynos5800 based
 peach-pi board
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier / Rahul,

On Wed, Aug 20, 2014 at 4:19 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> From: Rahul Sharma <rahul.sharma@samsung.com>
>
> Adding regulators for HDMI for Peach-pi board.
>
> Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
> Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  arch/arm/boot/dts/exynos5800-peach-pi.dts | 5 +++++
>  1 file changed, 5 insertions(+)

Reviewed-by: Doug Anderson <dianders@chromium.org>
