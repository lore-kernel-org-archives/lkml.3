Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaILQkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:40:07 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:46032 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaILQkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:40:05 -0400
MIME-Version: 1.0
In-Reply-To: <1410539161.314611261@f174.i.mail.ru>
References: <1410356809-26179-1-git-send-email-d.lavnikevich@sam-solutions.com>
	<1410537872-17274-1-git-send-email-d.lavnikevich@sam-solutions.com>
	<1410537872-17274-3-git-send-email-d.lavnikevich@sam-solutions.com>
	<1410539161.314611261@f174.i.mail.ru>
Date: Fri, 12 Sep 2014 13:40:02 -0300
Message-ID: <CAOMZO5C9_XwgcLvVWvxB1A306_Ehm17ZE111j6d+7MhudAhT0g@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v2 2/4] ARM: dts: pbab01: enable I2S audio on
 phyFLEX-i.MX6 boards
From: Fabio Estevam <festevam@gmail.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>,
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
        Kumar Gala <galak@codeaurora.org>, =devicetree@vger.kernel.org,
        Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 1:26 PM, Alexander Shiyan <shc_work@mail.ru> wrote:
> Fri, 12 Sep 2014 19:04:30 +0300 от Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>:
>> Audio on phyFLEX boards is presented by tlv320aic3007 codec connected
>> over SSI interface.
>>
>> Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
>> ---
> ...
>> +&ssi2 {
>> +     fsl,mode = "i2s-slave";
>> +     status = "okay";
>> +     #sound-dai-cells = <0>;
>> +};
>
> I have already sent patch to add "#sound-dai-cells" into all i.MX DT-files.
> Shawn, can you point us to this tree/commit?

https://git.kernel.org/cgit/linux/kernel/git/shawnguo/linux.git/commit/?h=for-next&id=36c7e8826cf32dd4dd34c71b526653b800414355
