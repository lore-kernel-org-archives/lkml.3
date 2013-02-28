Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3B1Wrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:47:33 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:45630 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3B1Wrb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:47:31 -0500
MIME-Version: 1.0
In-Reply-To: <20130228233235.5f279117@endymion.delvare>
References: <20130228110611.3ed77e92@endymion.delvare> <201302282312.51514.PeterHuewe@gmx.de>
 <20130228233235.5f279117@endymion.delvare>
From: Kent Yoder <shpedoikal@gmail.com>
Date: Thu, 28 Feb 2013 16:46:58 -0600
Message-ID: <CAM0nabENksjYahD49cx_GnnxN6XbEROo7zgyqP8s33zhcZUYYg@mail.gmail.com>
Subject: Re: [tpmdd-devel] [PATCH RESEND] char/tpm: Convert struct i2c_msg
 initialization to C99 format
To: Jean Delvare <khali@linux-fr.org>
Cc: =?ISO-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>,
        tpmdd-devel@lists.sourceforge.net, Kent Yoder <key@linux.vnet.ibm.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 4:32 PM, Jean Delvare <khali@linux-fr.org> wrote:
> On Thu, 28 Feb 2013 23:12:51 +0100, Peter Hüwe wrote:
>> thanks for resending.
>
> You're welcome.
>
>> Am Donnerstag, 28. Februar 2013, 11:06:11 schrieb Jean Delvare:
>> > From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
>> >
>> > Convert the struct i2c_msg initialization to C99 format. This makes
>> > maintaining and editing the code simpler. Also helps once other fields
>> > like transferred are added in future.
>> >
>> > Thanks to Julia Lawall for automating the conversion.
>> >
>> > Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
>> > Acked-by: Peter Huewe <peter.huewe@infineon.com>
>> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
>> > ---
>> > v2: removed zero initialization of flags.
>> >
>> > Patch already sent by Shubhrajyoti Datta on 2012-10-10.
>> >
>> >  drivers/char/tpm/tpm_i2c_infineon.c |   19 ++++++++++++++++---
>> >  1 file changed, 16 insertions(+), 3 deletions(-)
>>
>> As it was not yet applied I folded it into my patch
>> "Add support for new Infineon I2C TPM (SLB 9645 TT 1.2 I2C)"
>
> I'd suggest not to. Mixing actual changes with cleanups is generally
> discouraged.

  Yes, please don't do this.  Also because it makes it really
confusing for me to figure out whether something has been applied or
not and if I have the right people on the sign off.

  Peter, can you resend without it?  I'll have a new staging tree with
everything up in the next day or two.

Thanks,
Kent

> --
> Jean Delvare
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
