Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaIBTut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 15:50:49 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:64107 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbaIBTur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 15:50:47 -0400
MIME-Version: 1.0
In-Reply-To: <13302580.b33ghgBegF@diego>
References: <1409674469-12123-1-git-send-email-dianders@chromium.org>
	<13302580.b33ghgBegF@diego>
Date: Tue, 2 Sep 2014 12:50:46 -0700
X-Google-Sender-Auth: jngDqTg5z6B2Zt5Qp3uWafkCnl0
Message-ID: <CAD=FV=WiB6XnNFz9rPq=DOVU3qOr0yvmpdRN3DK1cKZ+K9hAhw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add input supplies to rk808 regulator
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Mark Brown <broonie@kernel.org>, Chris Zhong <zyw@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        zhangqing <zhangqing@rock-chips.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On Tue, Sep 2, 2014 at 12:48 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Dienstag, 2. September 2014, 09:14:27 schrieb Doug Anderson:
>> We want to specify the input supplies to the rk808 regulator.  This
>> patch series adds them to the driver.  Note that the bindings are
>> based atop Chris's most recent version at
>> <https://patchwork.kernel.org/patch/4817931/>.  If the regulator patch
>> is applied before Chris sends out his next version then I think Chris
>> could squash my bindings change (patch 2) into his next version.
>>
>>
>> Doug Anderson (2):
>>   regulator: RK808: Add proper input supplies for rk808
>
> Patch 1 didn't apply, as it didn't take the recent pdata removal Chris
> posted. After fixing this [0], it sucessfully solved the missing supplies
> I've seen on the weekend, so
>
> Tested-by: Heiko Stuebner <heiko@sntech.de>

Thanks!  ...ah, I guess I usually apply things with "git am -3" and it
didn't complain about applying my patch atop Chris's or not atop
Chris's.  Sorry for not making it clear.
