Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbaJNWnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:43:15 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:49289 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbaJNWnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:43:13 -0400
From: Max Schwarz <max.schwarz@online.de>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: wsa@the-dreams.de, heiko@sntech.de, olof@lixom.net, dianders@chromium.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, cf@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, hj@rock-chips.com, kever.yang@rock-chips.com,
        hl@rock-chips.com, caesar.wang@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v6] i2c: rk3x: adjust the LOW divison based on characteristics of SCL
Date: Wed, 15 Oct 2014 00:42:21 +0200
Message-ID: <1801397.7yxIcDsLaN@typ>
User-Agent: KMail/4.14.1 (Linux/3.15.7-031507-generic; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1413266961-3859-1-git-send-email-addy.ke@rock-chips.com>
References: <1413168244-3553-1-git-send-email-addy.ke@rock-chips.com> <1413266961-3859-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Z9UrUHVjZld8XNI/qPMUG/IJJOg24AHpAC1qf8M7hGU
 wuKfPff8isngmOcOoW9RrVDCVfVdtuBhl4awGi8/4rGvNELH8I
 bEinplbwpSu/5RyNU2UwxP0RzMDv+VlR0J6CNs6QzPd59DEaCg
 OrN67pj4aAxiI44ZWZptVlOIgETzKmmQ2ZmE74dsCxxMEwXoUl
 ybqas8l55YxSE7/qBz7D4CeVnFCDJWEF75xqkwBvMtm2qnAQCz
 lM+Oys6ianOEgrc8rntRKsK0w7/YGW/eobnZSfj5m6nRF1Iajv
 ipaDCgQcVacHiFZNDZzKXVo4qTpMtZcdA9taAsvaM8Fzm1Rdw=
 =
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Addy,

On Tuesday 14 October 2014 at 14:09:21, Addy Ke wrote:
> As show in I2C specification:
> - Standard-mode: the minimum HIGH period of the scl clock is 4.0us
>                  the minimum LOW period of the scl clock is 4.7us
> - Fast-mode: the minimum HIGH period of the scl clock is 0.6us
>              the minimum LOW period of the scl clock is 1.3us
> 
> I have measured i2c SCL waveforms in fast-mode by oscilloscope
> on rk3288-pinky board. the LOW period of the scl clock is 1.3us.
> It is so critical that we must adjust LOW division to increase
> the LOW period of the scl clock.
> 
> Thanks Doug for the suggestion about division formulas.
> 
> Tested-by: Heiko Stuebner <heiko@sntech.de>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>

Reviewed-by: Max Schwarz <max.schwarz@online.de>
Tested-by: Max Schwarz <max.schwarz@online.de>

Cheers,
  Max
