Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab3A3VPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:15:41 -0500
Received: from sylphide-consulting.com ([82.225.154.2]:60786 "EHLO
	freehackers.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3A3VPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:15:38 -0500
Message-ID: <51098D75.70500@freehackers.org>
Date: Wed, 30 Jan 2013 22:15:33 +0100
From: Thomas Capricelli <orzel@freehackers.org>
Organization: freehackers.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130121 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel failing to boot when compressed with bzip2
References: <1359554289.32505.58@driftwood>
In-Reply-To: <1359554289.32505.58@driftwood>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Il 30/01/2013 14:58, Rob Landley ha scritto:
>
> On 01/20/2013 03:55:05 PM, Thomas Capricelli wrote:
>
>> So my guess is that there's something badly broken in the bzip2 kernel
>> decompressing code.. ? There's both a regression between kernel 3.6 and
>> 3.7, and a problem with gcc-4.7.

> Worked For Me. I note that I built with gcc 4.2.1 and binutils 2.17
> (the last GPLv2 releases), and it's for i686

I guess that's the main point : my bug appears on AMD64, not i686, and i
can trigger It with either gcc-4.6 or gcc-4.7. I'm pretty sure it still
works with such an old gcc as 4.2.1.
I use binutils 2.23.1 but i doubt it matters here.

Again, amd64 using vanilla kernel releases (3.x.y)
    linux-3.6 with gcc-4.6 : ok
    linux-3.6 with gcc-4.7 : fail
    linux-3.7 with gcc-4.6 : fail
    linux-3.7 with gcc-4.7 : fail

I've had this BUNZIP2 option for very long, so i'm sure it was working
well with previous versions of both gcc and linux kernel.

greetings,
Thomas

-- 
Thomas Capricelli <orzel@freehackers.org>
http://www.freehackers.org/thomas/

