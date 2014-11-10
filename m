Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaKJJ3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:29:17 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:46985 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaKJJ3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:29:15 -0500
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: jay.xu@rock-chips.com
X-SENDER-IP: 199.193.78.80
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <9a71a0137f098427b82be88e0eb86371>
X-DNS-TYPE: 0
Message-ID: <54608556.3080308@rock-chips.com>
Date: Mon, 10 Nov 2014 17:28:54 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>, airlied@linux.ie,
        heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Lucas Stach <l.stach@pengutronix.de>, djkurtz@google.com,
        ykk@rock-chips.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org,
        jay.xu@rock-chips.com
Subject: Re: [PATCH V5 3/7] dw-hdmi: make checkpatch happy
References: <1415424410-7364-1-git-send-email-andy.yan@rock-chips.com> <1415424598-7533-1-git-send-email-andy.yan@rock-chips.com> <546083C5.8060502@imgtec.com>
In-Reply-To: <546083C5.8060502@imgtec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ZubairLK:
On 2014年11月10日 17:22, Zubair Lutfullah Kakakhel wrote:
> Hi Andy,
>
> In 3.18 rc4, I cannot find checkpatch errors in imx-hdmi.c
>
> Have these errors come during the previous 2 patches.
>
> If yes, then these changes need to be squashed into the previous
> patches. No patch should add a checkpatch error and then fix it in a later patch.
>
> Regards
> ZubairLK
i use checkpatch with --subjective
> On 08/11/14 05:29, Andy Yan wrote:
>> CHECK: Alignment should match open parenthesis
>> +       if ((hdmi->vic == 10) || (hdmi->vic == 11) ||
>> +               (hdmi->vic == 12) || (hdmi->vic == 13) ||
>>
>> CHECK: braces {} should be used on all arms of this statement
>> +       if (hdmi->hdmi_data.video_mode.mdvi)
>> [...]
>> +       else {
>> [...]
>>
>> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
>> ---
>>   drivers/gpu/drm/bridge/dw_hdmi.c | 97 ++++++++++++++++++++--------------------
>>   1 file changed, 48 insertions(+), 49 deletions(-)
>
>

