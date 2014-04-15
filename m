Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbaDOKk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:40:58 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:38357 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaDOKk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:40:56 -0400
MIME-Version: 1.0
In-Reply-To: <1397557331.1985.36.camel@x220>
References: <1397556735-2536-1-git-send-email-harinik@xilinx.com>
	<1397557331.1985.36.camel@x220>
Date: Tue, 15 Apr 2014 16:10:55 +0530
Message-ID: <CAFcVECJ+DADKdUdqSz8VHWTOYyphEjCJd9s-fVeC3uR7XfyjgQ@mail.gmail.com>
Subject: Re: [PATCH v2] spi: cadence: Add dependency on ARCH_ARM
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        michals@xilinx.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 15, 2014 at 3:52 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Tue, 2014-04-15 at 15:42 +0530, Harini Katakam wrote:
>> Add dependency on ARCH_ARM in Kconfig.
>> This is to fix the build error related to _relaxed IO.
>>
>> Signed-off-by: Harini Katakam <harinik@xilinx.com>
>> ---
>>
>> v2 changes:
>> Dependency on ARCH_ARM instead of restricting to ARCH_ZYNQ.
>>
>> ---
>>  drivers/spi/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
>> index b0f091b..32c27dd 100644
>> --- a/drivers/spi/Kconfig
>> +++ b/drivers/spi/Kconfig
>> @@ -150,6 +150,7 @@ config SPI_BUTTERFLY
>>
>>  config SPI_CADENCE
>>       tristate "Cadence SPI controller"
>> +     depends on ARCH_ARM
>
> Did you mean just ARM?

Please ignore patch, I will resend it.

Regards,
Harini
