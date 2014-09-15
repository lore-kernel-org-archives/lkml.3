Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbaIOMHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:07:18 -0400
Received: from s250.sam-solutions.net ([217.21.49.219]:59245 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaIOMHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:07:13 -0400
Message-ID: <5416D666.2050302@sam-solutions.net>
Date: Mon, 15 Sep 2014 15:07:02 +0300
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.net>
Organization: SaM Solutions
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>, Alexander Shiyan <shc_work@mail.ru>
CC: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Takashi Iwai <tiwai@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, <=devicetree@vger.kernel.org>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [alsa-devel] [PATCH v2 2/4] ARM: dts: pbab01: enable I2S audio
 on phyFLEX-i.MX6 boards
References: <1410356809-26179-1-git-send-email-d.lavnikevich@sam-solutions.com>	<1410537872-17274-1-git-send-email-d.lavnikevich@sam-solutions.com>	<1410537872-17274-3-git-send-email-d.lavnikevich@sam-solutions.com>	<1410539161.314611261@f174.i.mail.ru> <CAOMZO5C9_XwgcLvVWvxB1A306_Ehm17ZE111j6d+7MhudAhT0g@mail.gmail.com>
In-Reply-To: <CAOMZO5C9_XwgcLvVWvxB1A306_Ehm17ZE111j6d+7MhudAhT0g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/14 19:40, Fabio Estevam wrote:
> On Fri, Sep 12, 2014 at 1:26 PM, Alexander Shiyan <shc_work@mail.ru> wrote:
>> Fri, 12 Sep 2014 19:04:30 +0300 от Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>:
>>> Audio on phyFLEX boards is presented by tlv320aic3007 codec connected
>>> over SSI interface.
>>>
>>> Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
>>> ---
>> ...
>>> +&ssi2 {
>>> +     fsl,mode = "i2s-slave";
>>> +     status = "okay";
>>> +     #sound-dai-cells = <0>;
>>> +};
>> I have already sent patch to add "#sound-dai-cells" into all i.MX DT-files.
>> Shawn, can you point us to this tree/commit?
> https://git.kernel.org/cgit/linux/kernel/git/shawnguo/linux.git/commit/?h=for-next&id=36c7e8826cf32dd4dd34c71b526653b800414355
So should I base my next patchset on for-next branch of
git://git.kernel.org/pub/scm/linux/kernel/git/shawnguo/linux.git
?
