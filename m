Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab3KOKEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:04:13 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:64871 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab3KOKEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:04:08 -0500
MIME-Version: 1.0
In-Reply-To: <5285EED9.6090401@southpole.se>
References: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>
	<20131110055145.GA7947@chokladfabriken.org>
	<5285EED9.6090401@southpole.se>
Date: Fri, 15 Nov 2013 10:04:04 +0000
X-Google-Sender-Auth: 3PbapPQWM07vjDWA62OQ4VkJYGc
Message-ID: <CADj1OPA0s1-MM97+Qyk4e8BSUNQLN1+sDL5jF-=_HEAQRED_tw@mail.gmail.com>
Subject: Re: [ORLinux] [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
From: Andrew Back <andrew@abopen.com>
To: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Kevin Mehall <contact@kevinmehall.net>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@openrisc.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2013 09:52, Jonas Bonn <jonas@southpole.se> wrote:
> On 11/10/2013 06:51 AM, Stefan Kristiansson wrote:
>>
>> On Sat, Nov 09, 2013 at 09:37:31PM +0100, Geert Uytterhoeven wrote:
>>>
>>> Notable changes:
>>>    - Change flash0 to spansion,s25sl064p, due to kernel message
>>>      m25p80 spi32766.0: found s25sl064p, expected m25p10
>>
>>
>> This is due to Altera changing the EPCS chip on newer revisions
>> of that board, older versions are "relabeled" m25p10 and
>> newer once s25sl064p.
>> The change is fine though, you have to pick one.
>
>
> Actually, you want two DTS's: one for each version of the board with a
> 'compatible' property to help select the right one.  What do the revision
> numbers for these boards look like?

The bottom of my board has the following text:

P012060013
94V-0
HL9-VO
1227 F

Plus a barcode sticker which I assume is the S/N.

Best,

Andrew

--
Principal, AB Open Ltd
http://abopen.com
