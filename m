Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaBMPeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:34:11 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:60588 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaBMPeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:34:09 -0500
MIME-Version: 1.0
In-Reply-To: <201401082236.25135@pali>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <201312301531.29768@pali> <20131230145250.GA16904@earth.universe> <201401082236.25135@pali>
From: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Thu, 13 Feb 2014 16:33:28 +0100
Message-ID: <CAHYPw2EJC9RwgzXmGuQgh5_L6EMtS7MW8N3u2dR8KeVc0kb43g@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
To: Pavel Machek <pavel@ucw.cz>, Marcel Holtmann <marcel@holtmann.org>,
        Sebastian Reichel <sre@ring0.de>
Cc: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-01-08 22:36 GMT+01:00 Pali Rohár <pali.rohar@gmail.com>:
> On Monday 30 December 2013 15:52:51 Sebastian Reichel wrote:
>> > > > +MODULE_DESCRIPTION("Bluetooth h4 driver with nokia
>> > > > extensions"); +MODULE_LICENSE("GPL");
>> > > > +MODULE_AUTHOR("Ville Tervo");
>> > > > +MODULE_FIRMWARE(FW_NAME_TI1271_PRELE);
>> > > > +MODULE_FIRMWARE(FW_NAME_TI1271_LE);
>> > > > +MODULE_FIRMWARE(FW_NAME_TI1271);
>> > > > +MODULE_FIRMWARE(FW_NAME_BCM2048);
>> > > > +MODULE_FIRMWARE(FW_NAME_CSR);
>> > >
>> > > Do we actually have all these firmware files still
>> > > available. If not, then focus on the ones we have.
>> >
>> > Firmware files are available for download from nemo project:
>> >
>> > https://api.merproject.org/public/source/nemo:devel:hw:ti:om
>> > ap3:n900/bcm-bt-firmware/bcm-bt-firmware-0.21rc3.tar.bz2
>> > https://api.merproject.org/public/source/nemo:devel:hw:ti:o
>> > map3:n950-n9/ti-wl1273-bt-firmware/bt-firmware-ti1273_0.23+0
>> > m6.tar.gz
>>
>> Would be nice to have them added to the linux-firmware.git.
>>
>> -- Sebastian
>
> Can somebody send firmware files for inclusion to linux-firmware?
>
> --
> Pali Rohár
> pali.rohar@gmail.com

Now when driver is queued for staging, can somebody add firmware files
to linux-firmware repository? Note that without firmware files, driver
not working...

-- 
Pali Rohár
pali.rohar@gmail.com
