Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3COQKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:10:08 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.13]:23292 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754310Ab3COQKG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:10:06 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Mar 2013 12:10:06 EDT
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1363363411!5900289!18
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>, Kumar Amit Mehta <gmate.amit@gmail.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 15 Mar 2013 11:03:30 -0500
Subject: RE: [PATCH] staging: comedi: drivers: ni_atmio.c: Add a missing
 semicolon
Thread-Topic: [PATCH] staging: comedi: drivers: ni_atmio.c: Add a missing
 semicolon
Thread-Index: Ac4hYTsoly8fU1oORyGjFTiqtvrrzgANMDiQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020980106B39@AUSP01VMBX24.collaborationhost.net>
References: <1363335269-14903-1-git-send-email-gmate.amit@gmail.com>
 <5142ECB1.306@mev.co.uk>
In-Reply-To: <5142ECB1.306@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 15, 2013 2:41 AM, Ian Abbott wrote:
> On 2013-03-15 08:14, Kumar Amit Mehta wrote:
>> fix a missing end-of-statement by adding a semicolon.
>>
>> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
>> ---
>>   drivers/staging/comedi/drivers/ni_atmio.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/comedi/drivers/ni_atmio.c b/drivers/staging/comedi/drivers/ni_atmio.c
>> index 279f2cd..37372a1 100644
>> --- a/drivers/staging/comedi/drivers/ni_atmio.c
>> +++ b/drivers/staging/comedi/drivers/ni_atmio.c
>> @@ -467,7 +467,7 @@ static int ni_atmio_attach(struct comedi_device *dev,
>>   		return -EIO;
>>
>>   	dev->board_ptr = ni_boards + board;
>> -	boardtype = comedi_board(dev)
>> +	boardtype = comedi_board(dev);
>>
>>   	printk(" %s", boardtype->name);
>>   	dev->board_name = boardtype->name;
>
> Ironically, that was introduced by a patch titled "staging: comedi: 
> ni_atmio: fix build errors". :-)

My only excuse is that the coffee machine was broken...

Actually, I just realized that this driver as well as the others that depend
on ISAPNP were not being compiled on my Debian 6.0 64bit system . I
hacked my config to build the ones that depend on ISA but missed the
ISAPNP ones.

Sorry about the trouble.

Hartley

