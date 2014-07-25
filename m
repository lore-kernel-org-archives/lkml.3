Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760769AbaGYSIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:08:23 -0400
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:58175
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbaGYSIW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:08:22 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/12] staging: comedi: amplc_pc236: remove legacy PCI
 attach and tidy up
Thread-Topic: [PATCH 00/12] staging: comedi: amplc_pc236: remove legacy PCI
 attach and tidy up
Thread-Index: AQHPp+eR78LK/F6+QkKq8znELomRypuxDf7AgAAIocA=
Date: Fri, 25 Jul 2014 18:08:21 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F1E2D0@P3PWEX4MB008.ex4.secureserver.net>
References: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
 <DC148C5AA1CEBA4E87973D432B1C2D8825F1E16B@P3PWEX4MB008.ex4.secureserver.net>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825F1E16B@P3PWEX4MB008.ex4.secureserver.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 25, 2014 10:37 AM, Hartley Sweeten wrote:
> On Friday, July 25, 2014 2:05 AM, Ian Abbott wrote:
>> The "amplc_pc236" driver supports both ISA cards (Amplicon PC36AT) and PCI
>> cards (PCI236).  I plan to split it into separate drivers with a module for
>> common code, but let's reorganise it a bit first.
>>
>> The driver still supports manual attachment of PCI devices via the
>> `COMEDI_DEVCONFIG` ioctl and the comedi driver `attach` hook.  That can go,
>> though the attach hook is still needed for ISA devices.
>>
>> 01) staging: comedi: amplc_pc236: reformat header comments
>> 02) staging: comedi: amplc_pc236: remove some boilerplate comments
>> 03) staging: comedi: amplc_pc236: remove manual configuration of PCI boards
>> 04) staging: comedi: amplc_pc236: no need to manipulate PCI ref count
>> 05) staging: comedi: amplc_pc236: no need to set hw_dev
>> 06) staging: comedi: amplc_pc236: absorb pc236_pci_common_attach()
>> 07) staging: comedi: amplc_pc236: remove 'model' member
>> 08) staging: comedi: amplc_pc236: split pc236_boards[] into ISA & PCI
>> 09) staging: comedi: amplc_pc236: don't check bus type in attach
>> 10) staging: comedi: amplc_pc236: Simplify PCI board look-up
>> 11) staging: comedi: amplc_pc236: remove PCI device ID macros
>> 12) staging: comedi: amplc_pc236: set board_name before common attach
>>
>>  drivers/staging/comedi/drivers/amplc_pc236.c | 282 +++++++--------------------
>>  1 file changed, 74 insertions(+), 208 deletions(-)
>
> Ian,
>
> I'm not sure what happened but this entire series appears to be corrupt.
>
> Can you check it and repost?

Ignore that... The problem was on my end.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

