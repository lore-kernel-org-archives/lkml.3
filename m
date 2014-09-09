Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaIIU56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:57:58 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45647 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaIIU5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:57:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Javier Martinez Canillas <javier@dowhile0.org>,
        "Javier Martinez Canillas" <javier.martinez@collabora.co.uk>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CABxcv=mww1wcf+vo5uLxBrNZBVJhj9zvbwGu_oAKXm4XDUNvCQ@mail.gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "Yadwinder Singh Brar" <yadi.brar01@gmail.com>,
        "Doug Anderson" <dianders@chromium.org>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>,
        "Olof Johansson" <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1408350784-15577-1-git-send-email-javier.martinez@collabora.co.uk>
 <CABxcv=mww1wcf+vo5uLxBrNZBVJhj9zvbwGu_oAKXm4XDUNvCQ@mail.gmail.com>
Message-ID: <20140909205739.19023.50828@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v9 0/6] Add Maxim 77802 clocks support
Date: Tue, 09 Sep 2014 13:57:39 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Javier Martinez Canillas (2014-09-07 23:49:28)
> Hello Mike,
> 
> On Mon, Aug 18, 2014 at 10:32 AM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
> > This series add support for the clocks present in the Maxim
> > 77802 Power Managment IC. Previously, the series was part
> > of a bigger one [0] that aimed to add support for all the
> > devices in the max77802 PMIC. But now the Maxim 77802 PMIC
> > dependencies were already merged for 3.17 so the series can
> > be split and each driver can go through the relevant tree.
> >
> 
> This series was first posted for 3.17 and you acked the whole set but
> it missed 3.17 because had as a dependency some changes in the
> max77802 mfd driver. Those dependencies made for 3.17 and that's why I
> re-posted it for 3.18 about a month ago.
> 
> Since we are in 3.17-rc4 already, I'm afraid that this series may miss
> 3.18 again, is there anything else you need from me to pick this
> series? It will obviously conflict with Tomeu's "Per-user clock
> constraints" series [0] so if you want I can rebase it on top of your
> clk-next-tomeu-kirkwood-v2 branch [1].

Thanks for pinging me about it. I've pulled this series into clk-next
for 3.18. Everything is going to conflict with Tomeu's series so we'll
just handle that when it comes to merge his series (which I've since
removed from clk-next due to pending issues).

Regards,
Mike

> 
> Thanks a lot and best regards,
> Javier
> 
> [0]: https://lkml.org/lkml/2014/9/1/466
> [1]: https://git.linaro.org/people/mike.turquette/linux.git/shortlog/refs/heads/clk-next-tomeu-kirkwood-v2
