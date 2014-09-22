Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaIVErm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 00:47:42 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:42093 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753148AbaIVErj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 00:47:39 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <257d6776d39b20859b33bb7c17f8cd48>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <541FA9E2.60604@rock-chips.com>
Date: Mon, 22 Sep 2014 12:47:30 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] regulator: st-pwm: get voltage and duty table
 from dts
References: <1411354380-14326-1-git-send-email-zyw@rock-chips.com>	<1411354380-14326-2-git-send-email-zyw@rock-chips.com> <CAD=FV=VxqQhp8A_yGMe8U+_Z1DNzLvMp-Bsj_iEx=5mumeHpvw@mail.gmail.com>
In-Reply-To: <CAD=FV=VxqQhp8A_yGMe8U+_Z1DNzLvMp-Bsj_iEx=5mumeHpvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/22/2014 12:18 PM, Doug Anderson wrote:
> Chris,
>
> On Sun, Sep 21, 2014 at 7:52 PM, Chris Zhong <zyw@rock-chips.com> wrote:
>> Get voltage & duty table from device tree might be better, other platforms can also use this
>> driver without any modify.
>>
>> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
> No need to re-spin, but please remember that all tags should be
> bunched together (no blank lines).  In other words,
>
> YES:
>
>> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
> NO:
>
>> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
Thanks.
It seems the patman add the blank line, I will manually modify it next time.
