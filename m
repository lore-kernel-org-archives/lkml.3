Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965406Ab3DIJXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:23:47 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:48924 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936709Ab3DIJXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:23:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130409080653.GG24058@zurbaran>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
 <1363266691-15757-10-git-send-email-fabio.porcedda@gmail.com> <20130409080653.GG24058@zurbaran>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Tue, 9 Apr 2013 11:23:21 +0200
Message-ID: <CAHkwnC_Mq4YtY1SVFRAFPVBVajbK2dTnDOwNBQKeTdY_jDT5nA@mail.gmail.com>
Subject: Re: [PATCH 08/10] drivers: mfd: use module_platform_driver_probe()
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-ide <linux-ide@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>,
        linux-input <linux-input@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 10:06 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Fabio,
>
> On Thu, Mar 14, 2013 at 02:11:29PM +0100, Fabio Porcedda wrote:
>> This patch converts the drivers to use the
>> module_platform_driver_probe() macro which makes the code smaller and
>> a bit simpler.
>>
>> Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: Samuel Ortiz <sameo@linux.intel.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> ---
>>  drivers/mfd/davinci_voicecodec.c | 12 +-----------
>>  drivers/mfd/htc-pasic3.c         | 13 +------------
>>  2 files changed, 2 insertions(+), 23 deletions(-)
> Jingoo Han sent a larger patchset to convert many MFD drivers to
> module_platform_driver_probe(), including htc-pasic3 and davinci_voicecodec.
>
> See my mfd-next tree for more details.

I understand, thanks for letting me know.

It's my fault for having waited too long to send this patch set.

Best regards
--
Fabio Porcedda

> Cheers,
> Samuel.
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
