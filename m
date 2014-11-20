Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbaKTOoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:44:10 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:39126 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaKTOoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:44:08 -0500
MIME-Version: 1.0
In-Reply-To: <20141119210552.GA5464@lantern>
References: <20141114222640.GA39748@dtor-ws>
	<CAN+gG=FaovQETa3+qQsLoBBQnbZ8Q2uoQJD6_XvAmCCvGTHT1g@mail.gmail.com>
	<CAJBHPojp7JVG6KKgrNfbC-V5ibPs-j6+BnqrSDkxvak0vNGM8w@mail.gmail.com>
	<20141119181247.GE37989@dtor-ws>
	<CAJBHPohu71BXqyZ4u74tAiP84UcQhXgto34k8NtNHPgw61WvLQ@mail.gmail.com>
	<20141119183921.GF37989@dtor-ws>
	<CAJBHPog3qRMQgNnso_csUOgR30A6eFPx4PkTzfCzkB3Gd5oVfQ@mail.gmail.com>
	<20141119210552.GA5464@lantern>
Date: Thu, 20 Nov 2014 09:44:07 -0500
Message-ID: <CAN+gG=G6_ZXJQ5+3Oyf5pbVGOgyoqk_cOb_+EAADo4GecJ0yww@mail.gmail.com>
Subject: Re: [git pull] Input updates for 3.18-rc4
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Ulrik De Bie <ulrik.debie-os@e2big.org>
Cc: Marcus Overhagen <marcus.overhagen@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 4:05 PM,  <ulrik.debie-os@e2big.org> wrote:
> Hi,
>
> Thanks Dmitry, the fix you provided will mitigate the regression. But
> there might be more that is going on for v4 hardware. The detection
> of PACKET_TRACKPOINT can be made more strict.
> Thank you Marcus and Benjamin for the reports.
>
> Sorry for the regression, it was not expected that lowest nibble of packet[3]
> is 0x6 for non-trackpoint packets.
>
> So we have two laptops where
> 1) according to the msb of the capabilities has no trackpoint
> Benjamin, can you give feedback if the laptop has actually a trackpoint/stick/
> how else one calls that strange but convenient thing in the middle of the
> keyboard ?


Ulrik, the reporter said that there is no trackstick on his device.
The exact reference is Samsung Notebook NP900X3E-A01SE.

Cheers,
Benjamin
