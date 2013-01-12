Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab3ALLW6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 06:22:58 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:50034 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3ALLW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 06:22:57 -0500
MIME-Version: 1.0
In-Reply-To: <1425298.zMcaSB7taE@calvin>
References: <1520620637.200975.1355955029721.JavaMail.root@elliptictech.com>
	<1425298.zMcaSB7taE@calvin>
Date: Sat, 12 Jan 2013 12:22:56 +0100
Message-ID: <CADpTngUE7H9K2j3yCsm+TUx+X2RJZKaSz8kKn-ehpxzx1O2=fA@mail.gmail.com>
Subject: Re: 3.7.X vs 3.6.11 HP Folio 9470m brightness regression?
From: Fabio Coatti <fabio.coatti@gmail.com>
To: Tom St Denis <tstdenis@elliptictech.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing the same behaviour on 3.7.2; even
echo "NN" > brightness has no effect.
I've tried to look at changes between 3.6.11 and 3.7.2 but probably
this is beyond my skills ;)



2012/12/20 Fabio Coatti <fabio.coatti@gmail.com>:
> In data mercoledì 19 dicembre 2012 17:10:29, hai scritto:
>> ----- Original Message -----
>>
>> > From: "Fabio Coatti" <fabio.coatti@gmail.com>
>> > To: linux-kernel@vger.kernel.org
>> > Sent: Wednesday, 19 December, 2012 5:01:30 PM
>> > Subject: 3.7.X vs 3.6.11 HP Folio 9470m brightness regression?
>> >
>> > Hi,
>> > I'm testing kernels 3.7.X vs 3.6.11 on an HP Folio 9470m machine,
>> > i915
>> > driver for a VGA compatible controller: Intel Corporation 3rd Gen
>> > Core
>> > processor Graphics Controller (rev 09) 8086:0166
>> >
>> > With 3.6.11, the brightness can be correctly set using fn+f9/10: kde
>> > shows the bar and brightness changes.
>> >
>> > With 3.7.1 kde shows the percentage bar and
>> > /sys/class/backlight/acpi_video0/brightness is updated, but the
>> > screen
>> > brightness does not changes.
>>
>> I had a similar problem with my Dell laptop and i915/acpi...
>>
>> Is there another acpi_video? device?  In my case two showed up in 3.7
>> whereas in 3.6 there was one.  In 3.7 it was controlling the wrong one
>> apparently.
>
> Well, this seems not to be the case, I have only one acpi_video:
>
> calvin ~ # ls -l /sys/class/backlight/
> totale 0
> lrwxrwxrwx 1 root root 0 20 dic 09.20 acpi_video0 ->
> ../../devices/pci0000:00/0000:00:02.0/backlight/acpi_video0
>
> calvin ~ # ls -l /sys/devices/pci0000:00/0000:00:02.0/backlight
> totale 0
> drwxr-xr-x 3 root root 0 20 dic 09.20 acpi_video0
>
>
>
> --
> Fabio



--
Fabio
