Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaKKOsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:48:14 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:28854 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaKKOsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:48:13 -0500
Message-ID: <546221A2.30706@imgtec.com>
Date: Tue, 11 Nov 2014 14:48:02 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Yan <andy.yan@rock-chips.com>, <airlied@linux.ie>, <heiko@sntech.de>,
        <fabio.estevam@freescale.com>, <rmk+kernel@arm.linux.org.uk>
CC: <devel@driverdev.osuosl.org>, <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        Inki Dae <inki.dae@samsung.com>, <linux-rockchip@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Sean Paul <seanpaul@chromium.org>,
        <djkurtz@google.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        <ykk@rock-chips.com>, Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, Shawn Guo <shawn.guo@linaro.org>,
        <jay.xu@rock-chips.com>, Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v7 5/7] drm: bridge/dw-hdmi: add support for multi byte
 register width access
References: <1415710229-11935-1-git-send-email-andy.yan@rock-chips.com> <1415710432-12167-1-git-send-email-andy.yan@rock-chips.com> <54621B23.1020602@imgtec.com> <5462214F.4010504@rock-chips.com>
In-Reply-To: <5462214F.4010504@rock-chips.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/11/14 14:46, Andy Yan wrote:
> 
> On 2014年11月11日 22:20, Zubair Lutfullah Kakakhel wrote:
>> Hi Andy,
>>
>> This patch adds the reg-io-width binding.
>>
>> Hence the binding patch should come before it.
>>
>    do you mean that I should put dts binding patch
>    before this patch?

Yes. The patch adding the binding to the Documentation folder comes
before the driver implementing the binding.

ZubairLK

>> On 11/11/14 12:53, Andy Yan wrote:
>>> On rockchip rk3288, only word(32-bit) accesses are
>>> permitted for hdmi registers.  Byte width accesses (writeb,
>>> readb) generate an imprecise external abort.
