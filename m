Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3CNUg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:36:58 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.207]:46671 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607Ab3CNUg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:36:56 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Mar 2013 16:36:55 EDT
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-131.messagelabs.com!1363292676!11483919!141
X-Originating-IP: [216.166.12.178]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: driverdevel <devel@driverdev.osuosl.org>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 14 Mar 2013 15:28:13 -0500
Subject: RE: [-next] staging/comedi regressions
Thread-Topic: [-next] staging/comedi regressions
Thread-Index: Ac4g6un7uJRraWwsQzG+tUGAqazYlAAB0Drg
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020980106A1D@AUSP01VMBX24.collaborationhost.net>
References: <CAMuHMdXyBqwqn3aWpjwer5HYYqQvyMJTxJY-WeDGxLxkg_ZXQw@mail.gmail.com>
	<20130312222132.GA12477@kroah.com>
 <CAMuHMdWS5jqA=mXsCO-Bb84PuWDH-Qc17Jt=cWzTdKEah36hpw@mail.gmail.com>
In-Reply-To: <CAMuHMdWS5jqA=mXsCO-Bb84PuWDH-Qc17Jt=cWzTdKEah36hpw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2EKb4Rw000475

On Thursday, March 14, 2013 12:33 PM, Geert Uytterhoeven wrote:
> On Tue, Mar 12, 2013 at 11:21 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>> On Tue, Mar 12, 2013 at 11:13:50PM +0100, Geert Uytterhoeven wrote:
>>> m68k/allmodconfig:
>>>
>>> drivers/staging/comedi/drivers/ni_atmio.c: In function â€˜ni_isapnp_find_boardâ€™:
>>> drivers/staging/comedi/drivers/ni_atmio.c:353: error: â€˜n_ni_boardsâ€™
>>> undeclared (first use in this function)
>>> drivers/staging/comedi/drivers/ni_atmio.c:353: error: (Each undeclared
>>> identifier is reported only once
>>> drivers/staging/comedi/drivers/ni_atmio.c:353: error: for each
>>> function it appears in.)
>>> drivers/staging/comedi/drivers/ni_atmio.c: In function â€˜ni_getboardtypeâ€™:
>>> drivers/staging/comedi/drivers/ni_atmio.c:391: error: â€˜n_ni_boardsâ€™
>>> undeclared (first use in this function)
>>> drivers/staging/comedi/drivers/ni_atmio.c: In function â€˜ni_atmio_attachâ€™:
>>> drivers/staging/comedi/drivers/ni_atmio.c:470: error: â€˜boardtypeâ€™
>>> undeclared (first use in this function)
>>>
>>> http://kisskb.ellerman.id.au/kisskb/buildresult/8392062/
>>
>> Hartley already fixed it, this will show up in the next linux-next tree
>> as I commited the fix a few hours ago.
>
> Thanks, but now it fails differently:
>
> http://kisskb.ellerman.id.au/kisskb/buildresult/8398995/
> drivers/staging/comedi/drivers/ni_atmio.c:472:2: error: expected ';'
> before 'printk'
>
> There's a semicolon missing on the previous line.

Grrr... Sorry about that.

Patch coming in a minute.

Regards,
Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
