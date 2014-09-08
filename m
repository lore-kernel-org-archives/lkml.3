Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaIHGtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 02:49:32 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:54621 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaIHGt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 02:49:29 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.61.81]
In-Reply-To: <1408350784-15577-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1408350784-15577-1-git-send-email-javier.martinez@collabora.co.uk>
Date: Mon, 8 Sep 2014 08:49:28 +0200
Message-ID: <CABxcv=mww1wcf+vo5uLxBrNZBVJhj9zvbwGu_oAKXm4XDUNvCQ@mail.gmail.com>
Subject: Re: [PATCH v9 0/6] Add Maxim 77802 clocks support
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike,

On Mon, Aug 18, 2014 at 10:32 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> This series add support for the clocks present in the Maxim
> 77802 Power Managment IC. Previously, the series was part
> of a bigger one [0] that aimed to add support for all the
> devices in the max77802 PMIC. But now the Maxim 77802 PMIC
> dependencies were already merged for 3.17 so the series can
> be split and each driver can go through the relevant tree.
>

This series was first posted for 3.17 and you acked the whole set but
it missed 3.17 because had as a dependency some changes in the
max77802 mfd driver. Those dependencies made for 3.17 and that's why I
re-posted it for 3.18 about a month ago.

Since we are in 3.17-rc4 already, I'm afraid that this series may miss
3.18 again, is there anything else you need from me to pick this
series? It will obviously conflict with Tomeu's "Per-user clock
constraints" series [0] so if you want I can rebase it on top of your
clk-next-tomeu-kirkwood-v2 branch [1].

Thanks a lot and best regards,
Javier

[0]: https://lkml.org/lkml/2014/9/1/466
[1]: https://git.linaro.org/people/mike.turquette/linux.git/shortlog/refs/heads/clk-next-tomeu-kirkwood-v2
