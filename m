Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaKZPLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:11:50 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:42448 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaKZPLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:11:48 -0500
MIME-Version: 1.0
In-Reply-To: <20141126130451.5789e7f9@recife.lan>
References: <1416342155-26820-1-git-send-email-b.galvani@gmail.com>
	<1416342155-26820-3-git-send-email-b.galvani@gmail.com>
	<20141126130451.5789e7f9@recife.lan>
Date: Wed, 26 Nov 2014 16:11:35 +0100
X-Google-Sender-Auth: XNgRN0iulqS9sR-ILpyWuxKXGqM
Message-ID: <CAOQ7t2ZTLM6=-V-m5RX6fhY4-Jc-bMkmXspXUYHpCgyE-ui4iQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] media: rc: add driver for Amlogic Meson IR remote receiver
From: Carlo Caione <carlo@caione.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Beniamino Galvani <b.galvani@gmail.com>, Carlo Caione <carlo@caione.org>,
        linux-media@vger.kernel.org, Sean Young <sean@mess.org>,
        linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 4:04 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Em Tue, 18 Nov 2014 21:22:34 +0100
> Beniamino Galvani <b.galvani@gmail.com> escreveu:
>
>> Amlogic Meson SoCs include a infrared remote control receiver that can
>> operate in two modes: "NEC" mode in which the hardware decodes frames
>> using the NEC IR protocol, and "general" mode in which the receiver
>> simply reports the duration of pulses and spaces for software
>> decoding.
>>
>> This is a driver for the IR receiver that implements software decoding
>> of received frames.
>>
>> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
>> ---
>>  MAINTAINERS                 |   1 +
>>  drivers/media/rc/Kconfig    |  11 +++
>>  drivers/media/rc/Makefile   |   1 +
>>  drivers/media/rc/meson-ir.c | 216 ++++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 229 insertions(+)
>>  create mode 100644 drivers/media/rc/meson-ir.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 0662378..f1bc045 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -850,6 +850,7 @@ ARM/Amlogic MesonX SoC support
>>  M:   Carlo Caione <carlo@caione.org>
>>  L:   linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>>  S:   Maintained
>> +F:   drivers/media/rc/meson-ir.c
>>  N:   meson[x68]
>
> Hmm... you're putting this driver at Carlo's maintenance shoulders.
>
> I need his ack in order to apply this patch.

Acked-by: Carlo Caione <carlo@caione.org>


-- 
Carlo Caione
