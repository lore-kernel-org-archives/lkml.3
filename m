Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbaG2LJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:09:17 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:44252 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaG2LJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:09:15 -0400
X-263anti-spam: BIG:0;KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 1
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <3e13470d46544053fb2f68b9d16d6a01>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53D780D3.8070603@rock-chips.com>
Date: Tue, 29 Jul 2014 19:09:07 +0800
From: caesar <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Doug Anderson <dianders@chromium.org>, linux-pwm@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] pwm: add this patch to support the new pwm of
 Rockchip SoCs
References: <1405774529-26027-1-git-send-email-caesar.wang@rock-chips.com> <1405774529-26027-3-git-send-email-caesar.wang@rock-chips.com> <20140721085001.GG8843@ulmo> <53CD0E82.6030901@rock-chips.com> <20140721132723.GH15238@ulmo> <53D23192.4000908@rock-chips.com> <CAD=FV=XLjYQYmHxp3HBdwVmt6Wa7y-LEnsFKobsgVfFCp2-rRg@mail.gmail.com> <53D50601.1020106@rock-chips.com> <CAD=FV=UvF58NiY76FMi-TPVzsaWRJsR-M5HnHc7MRAWjwjY1jw@mail.gmail.com> <53D631B6.1050603@rock-chips.com> <20140729102212.GB21182@ulmo.nvidia.com>
In-Reply-To: <20140729102212.GB21182@ulmo.nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry,

在 2014年07月29日 18:22, Thierry Reding 写道:
> On Mon, Jul 28, 2014 at 07:19:18PM +0800, caesar wrote:
>> Doug,
>> 在 2014年07月28日 12:01, Doug Anderson 写道:
>>> Caesar,
>>>
>>> On Sun, Jul 27, 2014 at 7:00 AM, caesar <caesar.wang@rock-chips.com> wrote:
>>>> /*I think will be show the faill log:->
>>>>
>>>> * rockchip-pwm ff9301a0.pwm: can't request region for resource [mem
>>>> 0xff9301a0-0xff93019f]
>>>> */
>>>>
>>>> pc->base = devm_ioremap_resource(dev, regs);
>>> Did you actually code this up and try it and get this error?
>> Yeah.
> This should work if you properly set up the PWM subregion as a child of
> the LCDC region, which is what MFD will do for you.
>
> Thierry
As you say,should this change be occured by lcdc driver and dts?

The PWM driver don't need do any changes?

