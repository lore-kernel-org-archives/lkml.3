Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750987AbaHVS7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 14:59:45 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:43521 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750789AbaHVS7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 14:59:43 -0400
X-Greylist: delayed 722 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Aug 2014 14:59:43 EDT
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <9f80ea01c773295274f52941c743ed9d>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <53F79046.5020803@rock-chips.com>
Date: Sat, 23 Aug 2014 02:47:34 +0800
From: addy ke <addy.ke@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: dianders@chromium.org
CC: wsa@the-dreams.de, max.schwarz@online.de, heiko@sntech.de, olof@lixom.net,
        dmitry.torokhov@gmail.com, sergei.shtylyov@cogentembedded.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, cf@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, hj@rock-chips.com, kever.yang@rock-chips.com,
        hl@rock-chips.com, caesar.wang@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v4] i2c: rk3x: fix bug that cause transfer fails in master
 receive mode
References: <1408669991-9703-1-git-send-email-addy.ke@rock-chips.com>	<1408730452-3552-1-git-send-email-addy.ke@rock-chips.com> <CAD=FV=Vof8mOmCHkRyrhjGBewJqJaCu==1RfUZ+8C9Jm+UH50w@mail.gmail.com>
In-Reply-To: <CAD=FV=Vof8mOmCHkRyrhjGBewJqJaCu==1RfUZ+8C9Jm+UH50w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Addy,
> 
> On Fri, Aug 22, 2014 at 11:00 AM, Addy Ke <addy.ke@rock-chips.com> wrote:
>> In rk3x SOC, the I2C controller can receive/transmit up to 32 bytes data
>> in one chunk, so the size of data to be write/read to/from TXDATAx/RXDATAx
>> must be less than or equal 32 bytes at a time.
>>
>> Tested on rk3288-pinky board, elan receive 158 bytes data.
>>
>> Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> You only need a "Suggested-by" if the entire patch was suggested by
> someone.  If someone provides you review feedback you don't need it.
> 
> Said another way: in this case Dmitry didn't suggest that you need to
> fix the i2c controller to transmit 32 byte chunks (he only provided
> review feedback), so you shouldn't say this was Suggested-by him.
> 
> You also had my reviewed-by on a previous version so you could keep it.
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>

so, Do I need repost this patch or post a new one as patch v5?
> 
> 
> 
