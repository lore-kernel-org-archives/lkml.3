Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbaBNOI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:08:29 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:44747 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaBNOI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:08:26 -0500
MIME-Version: 1.0
In-Reply-To: <20140214133101.GA17796@e106331-lin.cambridge.arm.com>
References: <1392384058-14240-1-git-send-email-marek@goldelico.com>
	<20140214133101.GA17796@e106331-lin.cambridge.arm.com>
Date: Fri, 14 Feb 2014 15:08:25 +0100
Message-ID: <CAAfyv36Eo578K1LAdFJdKKjs800Gz2_kfJqvEcdD_U1qRCKY6w@mail.gmail.com>
Subject: Re: [PATCH] hwmon: twl4030-madc-hwmon: Add device tree support.
From: Belisko Marek <marek.belisko@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "jdelvare@suse.de" <jdelvare@suse.de>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "hns@goldelico.com" <hns@goldelico.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 2:31 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, Feb 14, 2014 at 01:20:58PM +0000, Marek Belisko wrote:
>> Signed-off-by: Marek Belisko <marek@goldelico.com>
>> ---
>>  Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt |  9 +++++++++
>>  drivers/hwmon/twl4030-madc-hwmon.c                             | 10 ++++++++++
>>  2 files changed, 19 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt
>>
>> diff --git a/Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt b/Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt
>> new file mode 100644
>> index 0000000..e8016d1
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt
>> @@ -0,0 +1,9 @@
>> +TWL4030 MADC hwmon.
>> +
>> +Required properties:
>> +- compatible: "ti,twl4030-madc-hwmon"
>> +
>> +Example:
>> +madc-hwmon {
>> +     compatible = "ti,twl4030-madc-hwmon";
>> +};
>
> Huh?
>
> What is this a binding for? From a look at the driver in mainline this
> just calls into functions from the twl4030 madc driver (which doesn't
> seem to have a binding).
I post bindings for twl4030-madc [1]. Without probing this driver
other things will not work (twl4030-madc-battery e.g.).
Is there better way to handle this situation?
>
> This doesn't look like a description of hardware, but rather a hack to
> get a Linux driver to probe. As far as I can see, no useful information
> is given by this binding.
>
> Thanks,
> Mark.

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
