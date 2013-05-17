Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3EQOH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 10:07:26 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:58038
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755382Ab3EQOHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 10:07:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zzbb2dI98dI9371Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
Message-ID: <519639A5.9070807@freescale.com>
Date: Fri, 17 May 2013 11:07:33 -0300
From: Fabio Estevam <fabio.estevam@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Hector Palacios <hector.palacios@digi.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Vasut <marex@denx.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>, <festevam@gmail.com>
Subject: Re: mxsfb on i.MX28 uses bypassed ref_xtal 24MHz clock for LCD
References: <5196375A.1070308@digi.com>
In-Reply-To: <5196375A.1070308@digi.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2013 10:57 AM, Hector Palacios wrote:

> On the MX28EVK board with the Seiko 4.3" LCD, I do not see the penguin
> or any image in v3.8 or v3.9 though the framebuffer device is present
> and correctly loaded and backlight on.
> This LCD works in kernel v2.6.35 with the same 24MHz frequency.
> @Fabio, does this LCD work out of the box on v3.9? Am I missing something?

Yes, works fine here.

Make sure you update both the kernel and dtb files on your tests.

Regards,

Fabio Estevam


