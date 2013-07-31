Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601Ab3GaSON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 14:14:13 -0400
Received: from up.free-electrons.com ([94.23.35.102]:49183 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753289Ab3GaSOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 14:14:11 -0400
Message-ID: <51F953EF.5060107@free-electrons.com>
Date: Wed, 31 Jul 2013 20:14:07 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Maxime Ripard'" <maxime.ripard@free-electrons.com>,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, hector.palacios@digi.com,
        "'Thomas Petazzoni'" <thomas@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCHv2 3/3] fb: backlight: HX8357: Add HX8369 support
References: <1374757513-2253-1-git-send-email-maxime.ripard@free-electrons.com> <1374757513-2253-4-git-send-email-maxime.ripard@free-electrons.com> <002301ce8991$f9b82060$ed286120$@samsung.com>
In-Reply-To: <002301ce8991$f9b82060$ed286120$@samsung.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 26/07/2013 01:52, Jingoo Han wrote:
> On Thursday, July 25, 2013 10:05 PM, Maxime Ripard wrote:
>> From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>>
>> Add support for the Himax HX8369 controller as it is quite similar to the
>> hx8357.
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> Acked-by: Jingoo Han <jg1.han@samsung.com>
>> ---
>>  drivers/video/backlight/hx8357.c | 221 ++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 206 insertions(+), 15 deletions(-)
>>
> [....]
>
>> +	ret = hx8357_spi_write_byte(lcdev, HX8357_SET_DISPLAY_ON);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	msleep(100);
> Hi Maxime Ripard,
>
> Could you add comment on this huge delay, too?

That one can actually be removed.

Regards,

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

