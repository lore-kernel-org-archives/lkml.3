Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaJANws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:52:48 -0400
Received: from s250.sam-solutions.net ([217.21.49.219]:54696 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaJANwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:52:47 -0400
Message-ID: <542C071D.1030507@sam-solutions.com>
Date: Wed, 1 Oct 2014 16:52:29 +0300
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Organization: SaM Solutions
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 2/4] ARM: dts: pbab01: enable I2S audio on phyFLEX-i.MX6
 boards
References: <1410537872-17274-1-git-send-email-d.lavnikevich@sam-solutions.com>	<1410854903-26419-1-git-send-email-d.lavnikevich@sam-solutions.com>	<1410854903-26419-3-git-send-email-d.lavnikevich@sam-solutions.com>	<CAOMZO5CgrQ6Wf6kStga40TUKx9dARygCNB4OYSUoG3c8eUYbrA@mail.gmail.com>	<542C0441.5080508@sam-solutions.com> <CAOMZO5BS6X2NTY4q7RKoKdhJNbEANSa2wXur3_Hyxp8nQn5Avw@mail.gmail.com>
In-Reply-To: <CAOMZO5BS6X2NTY4q7RKoKdhJNbEANSa2wXur3_Hyxp8nQn5Avw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/14 16:45, Fabio Estevam wrote:
> On Wed, Oct 1, 2014 at 10:40 AM, Dmitry Lavnikevich
> <d.lavnikevich@sam-solutions.com> wrote:
>
>>> No need to have this 'regulator-always-on'
>>>
>>
>> why is there no need for 'regulator-alweys-on'? I see it in
>
> For a regulator that is not GPIO controlled you don't need to pass
> 'regulator-always-on'.

Ok, I will remove it also.

I will wait some time for other notes on patches and resend patchset.

