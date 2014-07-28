Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaG1JyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:54:06 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.116]:60732 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbaG1JyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:54:02 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-4.tower-194.messagelabs.com!1406541238!26812089!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>
CC: DEVICE TREE <devicetree@vger.kernel.org>,
        LINUX ARM KERNEL <linux-arm-kernel@lists.infradead.org>,
        LINUX KERNEL <linux-kernel@vger.kernel.org>,
        LINUX SH <linux-sh@vger.kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        "Support Opensource" <Support.Opensource@diasemi.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: RE: [RESEND RFC V2] devicetree: Dialog Semiconductor consolidate
 existing vendor prefixes to standardise on 'dlg'
Thread-Topic: [RESEND RFC V2] devicetree: Dialog Semiconductor consolidate
 existing vendor prefixes to standardise on 'dlg'
Thread-Index: AQHPp1egR+JNVEE720Co5YFMnHyEKZuwTKkAgAT3x2A=
Date: Mon, 28 Jul 2014 09:53:56 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7D0B28E95@SW-EX-MBX02.diasemi.com>
References: <201407241554.s6OFsqbW031651@swsrvapps-01.diasemi.com>
 <20140725070002.GH7063@lee--X1>
In-Reply-To: <20140725070002.GH7063@lee--X1>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.61]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6S9sAnc014923

On 25 July 2014 08:00, Lee Jones wrote:

>On Thu, 24 Jul 2014, Opensource [Steve Twiss] wrote:
>> From: Steve Twiss <stwiss.opensource@diasemi.com>
>>
>> This patch series updates the device tree vendor prefix for
>> Dialog Semiconductor.
>>
>> Various methods are currently used throughout the kernel: 'diasemi',
>> 'dialog' and 'dlg'. Others have also been suggested.
>>
>> This patch set aims to consolidate the usage of the vendor prefix to
>> use a common standard. The prefix 'dlg' is used.
>>
>>
>> Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
>
>Didn't I Ack the MFD parts already?
>

Yes -- certainly.
 (I should have put them in the main body of the e-mail shouldn't I ..?)

I just need the SHMobile responses now.
I will try to make contact with those guys this week.

I have the following Acks so far.

>From: Rob Herring on 21 July 2014 16:43
>I'm okay with this, but it also needs acks from i.MX and SHMobile
>folks as it could break out of tree users.
>  Acked-by: Rob Herring <robh@kernel.org>

>From: Shawn Guo on 22 July 2014 02:38
>arch/arm/boot/dts/imx53-smd.dts                    |  2 +-
>arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |  2 +-
>  Acked-by: Shawn Guo <shawn.guo@freescale.com>

>From: Lee Jones on 22 July 2014 08:09
>For the MFD changes:
>  Acked-by: Lee Jones <lee.jones@linaro.org>

and

>From: Philipp Zabel on 24 July 2014 20:44
>  Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

Regards,
Steve

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
