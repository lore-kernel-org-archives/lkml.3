Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaIJHSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:18:10 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35136 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaIJHSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:18:09 -0400
Message-ID: <540FFB2B.6010203@collabora.co.uk>
Date: Wed, 10 Sep 2014 09:18:03 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier@dowhile0.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9 0/6] Add Maxim 77802 clocks support
References: <1408350784-15577-1-git-send-email-javier.martinez@collabora.co.uk> <CABxcv=mww1wcf+vo5uLxBrNZBVJhj9zvbwGu_oAKXm4XDUNvCQ@mail.gmail.com> <20140909205739.19023.50828@quantum>
In-Reply-To: <20140909205739.19023.50828@quantum>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike,

On 09/09/2014 10:57 PM, Mike Turquette wrote:
> Quoting Javier Martinez Canillas (2014-09-07 23:49:28)
>> 
>> Since we are in 3.17-rc4 already, I'm afraid that this series may miss
>> 3.18 again, is there anything else you need from me to pick this
>> series? It will obviously conflict with Tomeu's "Per-user clock
>> constraints" series [0] so if you want I can rebase it on top of your
>> clk-next-tomeu-kirkwood-v2 branch [1].
> 
> Thanks for pinging me about it. I've pulled this series into clk-next
> for 3.18. Everything is going to conflict with Tomeu's series so we'll
> just handle that when it comes to merge his series (which I've since
> removed from clk-next due to pending issues).
> 

Great, thanks a lot!

> Regards,
> Mike
> 

Best regards,
Javier
