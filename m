Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbaIQQyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:54:39 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:45367 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660AbaIQQyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:54:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140917165109.GM7960@sirena.org.uk>
References: <1410959280-29662-1-git-send-email-zyw@rock-chips.com>
	<1410959280-29662-2-git-send-email-zyw@rock-chips.com>
	<20140917165109.GM7960@sirena.org.uk>
Date: Wed, 17 Sep 2014 09:54:37 -0700
X-Google-Sender-Auth: Zd-TCv-rZL-jSIvIKD4co8QmDp8
Message-ID: <CAD=FV=UYdBDf+dvUp8U6qbW3CgrMP3vtF_yDamBYwSjZVJ42Qw@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulator: st-pwm: get voltage and duty table from dts
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Tao Huang <huangtao@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 17, 2014 at 9:51 AM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Sep 17, 2014 at 09:07:59PM +0800, Chris Zhong wrote:
>> Get voltage & duty table from device tree might be better, other platforms can also use this
>> driver without any modify.
>>
>> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>> ---
>>
>>  drivers/regulator/Kconfig  |    1 -
>>  drivers/regulator/st-pwm.c |   80 +++++++++++++++++++++++---------------------
>
> You need to update the binding document if you're updating the DT
> bindings.

Mark: See part 2 <https://patchwork.kernel.org/patch/4924381/>.
Unfortunately you weren't CCed on that.  It also should have been
patch #1, not patch #2.

Chris: please change the order and make sure Mark is CCed on the
bindings.  Probably anyone CCed on the code change should be on the
bindings change (and probably vice versa, but maybe not as critical).

-Doug
