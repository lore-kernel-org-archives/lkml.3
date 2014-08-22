Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaHVUEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:04:50 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:39542 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaHVUEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:04:49 -0400
MIME-Version: 1.0
In-Reply-To: <53F79046.5020803@rock-chips.com>
References: <1408669991-9703-1-git-send-email-addy.ke@rock-chips.com>
	<1408730452-3552-1-git-send-email-addy.ke@rock-chips.com>
	<CAD=FV=Vof8mOmCHkRyrhjGBewJqJaCu==1RfUZ+8C9Jm+UH50w@mail.gmail.com>
	<53F79046.5020803@rock-chips.com>
Date: Fri, 22 Aug 2014 13:04:48 -0700
X-Google-Sender-Auth: kZ36pprOuJTg5c3HI7iU61hdJmE
Message-ID: <CAD=FV=U9Rsjfnn-2ZxraDEJpOTcXVzJUN7e-67qiaFZFCmG-Sw@mail.gmail.com>
Subject: Re: [PATCH v4] i2c: rk3x: fix bug that cause transfer fails in master
 receive mode
From: Doug Anderson <dianders@chromium.org>
To: addy ke <addy.ke@rock-chips.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, max.schwarz@online.de,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        sergei.shtylyov@cogentembedded.com,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>,
        =?UTF-8?B?5pmT6IW+546L?= <caesar.wang@rock-chips.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addy,

On Fri, Aug 22, 2014 at 11:47 AM, addy ke <addy.ke@rock-chips.com> wrote:
>> Addy,
>>
>> On Fri, Aug 22, 2014 at 11:00 AM, Addy Ke <addy.ke@rock-chips.com> wrote:
>>> In rk3x SOC, the I2C controller can receive/transmit up to 32 bytes data
>>> in one chunk, so the size of data to be write/read to/from TXDATAx/RXDATAx
>>> must be less than or equal 32 bytes at a time.
>>>
>>> Tested on rk3288-pinky board, elan receive 158 bytes data.
>>>
>>> Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>>
>> You only need a "Suggested-by" if the entire patch was suggested by
>> someone.  If someone provides you review feedback you don't need it.
>>
>> Said another way: in this case Dmitry didn't suggest that you need to
>> fix the i2c controller to transmit 32 byte chunks (he only provided
>> review feedback), so you shouldn't say this was Suggested-by him.
>>
>> You also had my reviewed-by on a previous version so you could keep it.
>>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
>
> so, Do I need repost this patch or post a new one as patch v5?

Tags are typically something that the maintainer (Wolfram) can adjust
when he adds his own.  I think it's OK and he can remove the
"Suggested-by".  However, if Wolfram responds and asks you to respin
then you should follow his advice.


-Doug
