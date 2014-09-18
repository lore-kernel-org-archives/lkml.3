Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbaIRDg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 23:36:57 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:63787 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263AbaIRDg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 23:36:56 -0400
MIME-Version: 1.0
In-Reply-To: <541A3765.50606@rock-chips.com>
References: <1410959280-29662-1-git-send-email-zyw@rock-chips.com>
	<1410959280-29662-2-git-send-email-zyw@rock-chips.com>
	<20140917165109.GM7960@sirena.org.uk>
	<CAD=FV=UYdBDf+dvUp8U6qbW3CgrMP3vtF_yDamBYwSjZVJ42Qw@mail.gmail.com>
	<541A3765.50606@rock-chips.com>
Date: Wed, 17 Sep 2014 20:36:55 -0700
X-Google-Sender-Auth: RGGDZNfu0o2rlozBosWxLLAKqHY
Message-ID: <CAD=FV=XVFfvYORrEPhBKxHDsMUOcqhg1Eyq5vsxYAkBh1QJ77w@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulator: st-pwm: get voltage and duty table from dts
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Mark Brown <broonie@kernel.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Tao Huang <huangtao@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Wed, Sep 17, 2014 at 6:37 PM, Chris Zhong <zyw@rock-chips.com> wrote:
>> Chris: please change the order and make sure Mark is CCed on the
>> bindings.  Probably anyone CCed on the code change should be on the
>> bindings change (and probably vice versa, but maybe not as critical).
>>
>> -Doug
>>
>>
> Thanks.
> I should not only use patman's script to created cc list.

Yup, patman relies on get_maintainer and that's not perfect.  I tend
to rely heavily on it but it's good to sanity check...


Speaking of which: Lee, do you think it would be a good idea to add
yourself as a MAINTAINER for st-pwm?

  (next-20140917))$ ./scripts/get_maintainer.pl -f drivers/regulator/st-pwm.c
  Liam Girdwood <lgirdwood@gmail.com> (supporter:VOLTAGE AND CURRE...)
  Mark Brown <broonie@kernel.org> (supporter:VOLTAGE AND CURRE...)
  Grant Likely <grant.likely@linaro.org> (maintainer:OPEN FIRMWARE AND...)
  Rob Herring <robh+dt@kernel.org> (maintainer:OPEN FIRMWARE AND...)
  linux-kernel@vger.kernel.org (open list:VOLTAGE AND CURRE...)
  devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...)


...ideally whatever rule added would also catch the bindings file when
Chris adds it.


-Doug
