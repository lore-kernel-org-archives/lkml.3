Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab3GKN5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:57:15 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:35594 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab3GKN5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:57:13 -0400
MIME-Version: 1.0
X-Originating-IP: [72.73.18.11]
In-Reply-To: <20130711104701.1f1c5fda@endymion.delvare>
References: <002901ce77e9$dfac4f20$9f04ed60$@lucidpixels.com>
	<20130703144201.GA10323@roeck-us.net>
	<20130711104701.1f1c5fda@endymion.delvare>
Date: Thu, 11 Jul 2013 09:57:12 -0400
Message-ID: <CAO9zADyZvMpJoD68QKQ9bw0dMLdMvwK3Yqz=E5zTWWoFCoqncg@mail.gmail.com>
Subject: Re: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro
 X9SRL-F motherboard
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for these details!

On Thu, Jul 11, 2013 at 4:47 AM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Guenter, Justin,
>
> On Wed, 3 Jul 2013 07:42:01 -0700, Guenter Roeck wrote:
>> On Wed, Jul 03, 2013 at 08:35:59AM -0400, Justin Piszcz wrote:
>> > I also found:
>> > http://www.lm-sensors.org/wiki/Configurations/SuperMicro/X9SRA
>> >
>> > Does Super Micro also have such a config file for the X9SRL-F?
>> > This board uses a NCT6776F.
>>
>> Supermicro does not provide configuration files. You can take the above file,
>> test and update it, and let us know so we can add it to the wiki.
>
> Actually they do provide configuration information. They have their own
> tool names SuperDoctor, which can be downloaded from:
>   ftp://ftp.supermicro.com/utility/SuperDoctor_II/Linux/Release/
>
> If you look at file AllSuperD.ini, you'll find per-board entries
> describing the input mapping. It is very helpful when writing a custom
> libsensors configuration file for the board in question. It takes some
> knowledge of the monitoring chip or its driver though, as the ini file
> references register addresses ("Offset" in the file.)
>
> A gave a quick look and at least the voltage input mapping (and
> presumably the voltage scaling factors as well) is similar to the
> X9SRA so you can reuse this part of the X9SRA configuration file.
>
> Hope that helps,
> --
> Jean Delvare
