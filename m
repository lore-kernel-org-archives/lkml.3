Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287Ab3FSJJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:09:31 -0400
Received: from us02smtp2.synopsys.com ([198.182.60.77]:54878 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869Ab3FSJJ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:09:28 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Michal Simek <monstr@monstr.eu>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "dahinds@users.sourceforge.net" <dahinds@users.sourceforge.net>,
        "Mischa Jonker" <Mischa.Jonker@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Subject: Re: xsysace driver support on arches other than PPC/Microblaze
Thread-Topic: xsysace driver support on arches other than PPC/Microblaze
Thread-Index: AQHObMrbNBC9i1xSckWGhX+xeSwphw==
Date: Wed, 19 Jun 2013 09:09:24 +0000
Message-ID: <4881796E12491D4BB15146FE0209CE643F5F09C9@DE02WEMBXB.internal.synopsys.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
 <CACxGe6uHx4KdZRgAyL-wQ2GurojAH0eTa6YRCoSuCg89BAvBTA@mail.gmail.com>
 <CAHTX3dKPWg35Az8eE45AGriPZh2G6LLaQMynhFPKSZ+7UvM=9g@mail.gmail.com>
 <201302121725.07641.arnd@arndb.de>
 <4881796E12491D4BB15146FE0209CE643F5F0910@DE02WEMBXB.internal.synopsys.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.121.8.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 12:56 PM, Alexey Brodkin wrote:
[]
> For (2) I may expect that plain change of used accessor from "le" to
> "be" will break "xsysace" on PPC/Micropblaze.

Just recalled that discussion of the first patch continued in another 
thread: https://patchwork.kernel.org/patch/2130081/

It has a snipped of proposed change for (2).

but this thread as well ended up without any action.

Regards,
Alexey
