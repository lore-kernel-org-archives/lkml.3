Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaAWRvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:51:11 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54064 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104AbaAWRvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:51:08 -0500
MIME-Version: 1.0
In-Reply-To: <20140123172534.GA2665@katana>
References: <CAOMwXhMVgcVVWiUYbEgGcM+K5bZmKA3LO0=jZCEsyJak1TbTSA@mail.gmail.com>
	<20140123172534.GA2665@katana>
Date: Thu, 23 Jan 2014 17:51:07 +0000
X-Google-Sender-Auth: UHn_LZ2ON1A71vyPgcz5LHh_q5M
Message-ID: <CAOMwXhPqnSNWtPMo7Qrr-O3qAqtjju7au7Mudckp7kN50yQW3A@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add at24 based EEPROMs to the eeprom_dev hardware class
From: Laszlo Papp <lpapp@kde.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Curt Brune <curt@cumulusnetworks.com>,
        Thomas De Schampheleire <patrickdepinguin@gmail.com>,
        gregkh@linuxfoundation.org,
        Shrijeet Mukherjee <shm@cumulusnetworks.com>, wolfram@the-dreams.de,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 5:25 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> Hi,
>
> No need to quote the whole message if you reply only to a bit of it.
>
>> >  module_init(at24_init);
>> >
>> >  static void __exit at24_exit(void)
>> >  {
>> >         i2c_del_driver(&at24_driver);
>> >  }
>> >  module_exit(at24_exit);
>>
>> Couldn't you use module_i2c_driver() instead of this?
>
> He didn't write that code. It doesn't have a + at the beginning. He used
> the whole driver as context, which is highly unusual. A context of 3
> lines is usually good enough.

Right. I will send a patch addressing that separately.

>> >  MODULE_DESCRIPTION("Driver for most I2C EEPROMs");
>> >  MODULE_AUTHOR("David Brownell and Wolfram Sang");
>>
>> I would personally put your name in here if I were you, otherwise
>> David and Wolfram might get contacted by some people instead of you
>> (at least based on this).
>
> See above. He changed only 10 lines. Not enough for copyright IMO.

Well, it is not the Copyrights section, or you are saying the same
people should go to MODULE_AUTHOR as in the Copyrights section, even
if it is potentially several names? I thought this would be the name
of the person who put the file together even if from existing sources.

>> PS.: Fixing the broken i2c mailing list typo, and updating Wolfram's
>> address from the broken (obsolete?) version.
>
> It came through to the i2c list? What was wrong?

Yes, it did, _after_ fixing the typo in the mailing list address.
Check the original mailing list address typed for details.
