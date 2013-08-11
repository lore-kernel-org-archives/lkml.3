Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3HKJEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 05:04:11 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:21493 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3HKJEE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 05:04:04 -0400
From: "Gujare, Rupesh" <Rupesh.Gujare@atmel.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: RE: linux-next: Tree for Aug 9 (staging/ozwpan)
Thread-Topic: linux-next: Tree for Aug 9 (staging/ozwpan)
Thread-Index: AQHOlhdOR1TZtkq1eUikrvRw5sW+H5mO8WqAgADFS5E=
Date: Sun, 11 Aug 2013 09:04:00 +0000
Message-ID: <CB57019DFBA97B45884DCA732411B955341FA6C8@hnombx02.corp.atmel.com>
References: <20130809161540.f65dd6412ac59d49a32881c8@canb.auug.org.au>
 <5206BB86.2000604@infradead.org>,<5206C9AB.8050706@infradead.org>
In-Reply-To: <5206C9AB.8050706@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.161.30.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
From: Randy Dunlap [rdunlap@infradead.org]
Sent: 11 August 2013 00:15
To: Stephen Rothwell
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org; Gujare, Rupesh; Greg Kroah-Hartman
Subject: Re: linux-next: Tree for Aug 9 (staging/ozwpan)

On 08/10/13 15:15, Randy Dunlap wrote:
> On 08/08/13 23:15, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20130808:
>>
>> *crickets*
>>
>
> on i386:
>
> ERROR: "__divdi3" [drivers/staging/ozwpan/ozwpan.ko] undefined!
>

2 occurrences of this in oz_hcd_heartbeat().

>
>
> Apologies if this has already been reported/fixed.
>

Yes, It had been already been fixed here :-

http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2013-August/040091.html
I have been waiting for Greg to apply this patch to his tree.

--
Regards,
Rupesh Gujare