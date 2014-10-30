Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbaJ3Gy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:54:26 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:55893 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147AbaJ3GyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:54:24 -0400
X-Greylist: delayed 16354 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2014 02:54:22 EDT
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <84ddbc499513bfd811c15bd077de39fc>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5451E08E.2050701@rock-chips.com>
Date: Thu, 30 Oct 2014 14:54:06 +0800
From: addy ke <addy.ke@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: dianders@chromium.org
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, tgih.jun@samsung.com, jh80.chung@samsung.com,
        chris@printf.net, ulf.hansson@linaro.org, dinguyen@altera.com,
        heiko@sntech.de, olof@lixom.net, sonnyrao@chromium.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, lintao@rock-chips.com, chenfen@rock-chips.com,
        zyf@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, hj@rock-chips.com,
        kever.yang@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com
Subject: Re: [PATCH] mmc: dw_mmc: add a quirk for the defferent bit of sdio
 interrupt
References: <1414635679-12565-1-git-send-email-addy.ke@rock-chips.com>	<CAD=FV=Uo3gcnGFn=gpZhV1r+qyZxJ_tpAEiSsu06P=csHTScug@mail.gmail.com> <CAD=FV=VgCjhO5n5VPo_8QmMPBg1ZDMR8nvmVHS=Le8bxEFmzeA@mail.gmail.com>
In-Reply-To: <CAD=FV=VgCjhO5n5VPo_8QmMPBg1ZDMR8nvmVHS=Le8bxEFmzeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Doug,

On 2014/10/30 12:49, Doug Anderson wrote:
> Addy,
> 
> On Wed, Oct 29, 2014 at 9:41 PM, Doug Anderson <dianders@chromium.org> wrote:
>> You can avoid a lot of "if" tests if you just add a new "sdio->id"
> 
> Whoops, I mean "slot->sdio_id"
> 

To use "slot->sdio_id", I think the subject must be changed.
So I will drop this patch ,and send new patch to use "slot->sdio_id" for this difference.

thank you!

> 
> 

