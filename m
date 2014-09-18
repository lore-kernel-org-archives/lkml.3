Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbaIRBhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 21:37:50 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:45336 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757342AbaIRBht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 21:37:49 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <91155370b52893a355bebca801139f68>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <541A3765.50606@rock-chips.com>
Date: Thu, 18 Sep 2014 09:37:41 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Mark Brown <broonie@kernel.org>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Tao Huang <huangtao@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] regulator: st-pwm: get voltage and duty table from
 dts
References: <1410959280-29662-1-git-send-email-zyw@rock-chips.com>	<1410959280-29662-2-git-send-email-zyw@rock-chips.com>	<20140917165109.GM7960@sirena.org.uk> <CAD=FV=UYdBDf+dvUp8U6qbW3CgrMP3vtF_yDamBYwSjZVJ42Qw@mail.gmail.com>
In-Reply-To: <CAD=FV=UYdBDf+dvUp8U6qbW3CgrMP3vtF_yDamBYwSjZVJ42Qw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/18/2014 12:54 AM, Doug Anderson wrote:
> Hi,
>
> On Wed, Sep 17, 2014 at 9:51 AM, Mark Brown <broonie@kernel.org> wrote:
>> On Wed, Sep 17, 2014 at 09:07:59PM +0800, Chris Zhong wrote:
>>> Get voltage & duty table from device tree might be better, other platforms can also use this
>>> driver without any modify.
>>>
>>> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>>> ---
>>>
>>>   drivers/regulator/Kconfig  |    1 -
>>>   drivers/regulator/st-pwm.c |   80 +++++++++++++++++++++++---------------------
>> You need to update the binding document if you're updating the DT
>> bindings.
> Mark: See part 2 <https://patchwork.kernel.org/patch/4924381/>.
> Unfortunately you weren't CCed on that.  It also should have been
> patch #1, not patch #2.
>
> Chris: please change the order and make sure Mark is CCed on the
> bindings.  Probably anyone CCed on the code change should be on the
> bindings change (and probably vice versa, but maybe not as critical).
>
> -Doug
>
>
Thanks.
I should not only use patman's script to created cc list.
