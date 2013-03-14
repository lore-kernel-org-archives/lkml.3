Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3CNTdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 15:33:32 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:58569 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3CNTda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 15:33:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130312222132.GA12477@kroah.com>
References: <CAMuHMdXyBqwqn3aWpjwer5HYYqQvyMJTxJY-WeDGxLxkg_ZXQw@mail.gmail.com>
	<20130312222132.GA12477@kroah.com>
Date: Thu, 14 Mar 2013 20:33:29 +0100
X-Google-Sender-Auth: c7Zim3bilP2GsMyFcAsKRXQQfnc
Message-ID: <CAMuHMdWS5jqA=mXsCO-Bb84PuWDH-Qc17Jt=cWzTdKEah36hpw@mail.gmail.com>
Subject: Re: [-next] staging/comedi regressions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 11:21 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Mar 12, 2013 at 11:13:50PM +0100, Geert Uytterhoeven wrote:
>> m68k/allmodconfig:
>>
>> drivers/staging/comedi/drivers/ni_atmio.c: In function ‘ni_isapnp_find_board’:
>> drivers/staging/comedi/drivers/ni_atmio.c:353: error: ‘n_ni_boards’
>> undeclared (first use in this function)
>> drivers/staging/comedi/drivers/ni_atmio.c:353: error: (Each undeclared
>> identifier is reported only once
>> drivers/staging/comedi/drivers/ni_atmio.c:353: error: for each
>> function it appears in.)
>> drivers/staging/comedi/drivers/ni_atmio.c: In function ‘ni_getboardtype’:
>> drivers/staging/comedi/drivers/ni_atmio.c:391: error: ‘n_ni_boards’
>> undeclared (first use in this function)
>> drivers/staging/comedi/drivers/ni_atmio.c: In function ‘ni_atmio_attach’:
>> drivers/staging/comedi/drivers/ni_atmio.c:470: error: ‘boardtype’
>> undeclared (first use in this function)
>>
>> http://kisskb.ellerman.id.au/kisskb/buildresult/8392062/
>
> Hartley already fixed it, this will show up in the next linux-next tree
> as I commited the fix a few hours ago.

Thanks, but now it fails differently:

http://kisskb.ellerman.id.au/kisskb/buildresult/8398995/
drivers/staging/comedi/drivers/ni_atmio.c:472:2: error: expected ';'
before 'printk'

There's a semicolon missing on the previous line.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
