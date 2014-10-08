Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbaJHQag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:30:36 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:55290 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaJHQae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:30:34 -0400
MIME-Version: 1.0
In-Reply-To: <5434F9E4.7020109@collabora.co.uk>
References: <1412671438-25399-1-git-send-email-zyw@rock-chips.com>
	<CAD=FV=W_6_JSn5ZWEG7YBDw5xf+tGReSB-WCV798gBqXyhikgg@mail.gmail.com>
	<5434F9E4.7020109@collabora.co.uk>
Date: Wed, 8 Oct 2014 09:30:33 -0700
X-Google-Sender-Auth: YfdWqptClgzayqKzsT2qyLPhV2g
Message-ID: <CAD=FV=V7p8h-x3b7m8MB4oT=X=HnFijjmao_V3tVE21BkNgdPw@mail.gmail.com>
Subject: Re: [PATCH] regulator: rk808: Add support setting suspend voltage
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Chris Zhong <zyw@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Wed, Oct 8, 2014 at 1:46 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> Yes, you will need Chanwoo's series in order to use this. If also the
> driver needs to set a default initial regulator operating mode, it will
> need the series I'll post today but in that case also a .set_mode handler
> is needed.

In rk808 the mode isn't as complicated as the Maxim PMICs.  There's
only a "on in sleep" vs "off in sleep", not different sleep modes.
Also the "on" vs "off" isn't mixed up with the sleep mode setting.

...so I think that the "mode" stuff isn't needed for rk808.

-Doug
