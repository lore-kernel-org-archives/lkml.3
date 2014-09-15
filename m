Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaIOMFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:05:19 -0400
Received: from s250.sam-solutions.net ([217.21.49.219]:46330 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaIOMFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:05:17 -0400
Message-ID: <5416D5E2.5050109@sam-solutions.net>
Date: Mon, 15 Sep 2014 15:04:50 +0300
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.net>
Organization: SaM Solutions
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>,
        Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
CC: <=devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <perex@perex.cz>, <tiwai@suse.de>
Subject: Re: [PATCH v2 2/4] ARM: dts: pbab01: enable I2S audio on phyFLEX-i.MX6
 boards
References: <1410356809-26179-1-git-send-email-d.lavnikevich@sam-solutions.com> <1410537872-17274-1-git-send-email-d.lavnikevich@sam-solutions.com> <1410537872-17274-3-git-send-email-d.lavnikevich@sam-solutions.com> <1410538486.406482403@f174.i.mail.ru>
In-Reply-To: <1410538486.406482403@f174.i.mail.ru>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/14 19:14, Alexander Shiyan wrote:
> Fri, 12 Sep 2014 19:04:30 +0300 от Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>:
>> +&audmux {
>> +	status = "okay";
>> +
>> +	ssi2 {
>> +		fsl,audmux-port = <1>;
>> +		fsl,port-config = <0xa5000000 0x00008000>;
>> +	};
>> +	pins5 {
>> +		fsl,audmux-port = <4>;
>> +		fsl,port-config = <0x00000000 0x00002000>;
>> +	};
>> +};
> You should use defines from sound/fsl-imx-audmux.h for audmux.
Ok, will change it in next patchset version.
