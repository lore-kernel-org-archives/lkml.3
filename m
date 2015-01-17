Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbbAQAEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 19:04:12 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:62397 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbbAQAEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 19:04:10 -0500
MIME-Version: 1.0
In-Reply-To: <1421413862.17198.23.camel@linux-0dmf.site>
References: <8322374EB97AA24A95D0DDBFC8F1CA1DBF987B@SISMBEV01.sis.com.tw>
	<1421063449.12454.17.camel@linux-0dmf.site>
	<CAKR5kVFXy4GdZdHFnW2AAjqkcHfgfM5b0NhkOa079bftOoKqUQ@mail.gmail.com>
	<8322374EB97AA24A95D0DDBFC8F1CA1DBF9DE5@SISMBEV01.sis.com.tw>
	<8322374EB97AA24A95D0DDBFC8F1CA1DBF9E1B@SISMBEV01.sis.com.tw>
	<1421413862.17198.23.camel@linux-0dmf.site>
Date: Fri, 16 Jan 2015 16:04:08 -0800
Message-ID: <CAKdAkRSGumi5rK9ToxUoQXo9OrTutPTgv2z8pRQix6gwDS45EA@mail.gmail.com>
Subject: Re: [PATCH 1/2] INPUT/HID: add touch support for SiS touch driver
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: =?UTF-8?B?5pu+5am36JGzICh0YW1teV90c2VuZyk=?= <tammy_tseng@sis.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        tammy0524@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 5:11 AM, Oliver Neukum <oneukum@suse.de> wrote:
> On Fri, 2015-01-16 at 18:59 +0800, 曾婷葳 (tammy_tseng) wrote:
>> Hey, Oliver
>>
>> On Mon, Jan 12, 2015 at 7:50 PM, Oliver Neukum <oneukum@suse.de> wrote:
>> On Mon, 2015-01-12 at 18:53 +0800, 曾婷葳 (tammy_tseng) wrote:
>> > > (Skip the code diff...)
>> >
>> > Again macros for endianness
>> >
>> > And the driver has a great number of conditional compilations are they
>> > really needed? The driver as is has a number of issues and is hard to
>> > review due to the use of "//" for comments and a lot of conditional
>> > compilation and unnecessary variables used for constants. Could you
>> > fix this up and resubmit?
>>
>> Thanks for the reply. I've modified the code (sis_i2c.c/sis_i2c.h/Kconfig/Makefile) to fix them.
>> Please help check them if anything needs to fix.
>
> Hi,
>
> I started from the lower end. I hope you find my comments
> useful. A few general points need to be made before the
> code is ready for review (it is obviously not ready for
> inclusion)

Also:

- it was sent as base64 so it can't be applied using normal tools
- it has DOS line endings
- even after decoding it does not apply
- dtor@dtor-ws:~/kernel/work$ ./scripts/checkpatch.pl --no-signoff
sis-decoded.patch
...
total: 677 errors, 355 warnings, 1479 lines checked

Please make sure your code at least conforms to the kernel coding
style before resubmitting.

Thanks.

-- 
Dmitry
