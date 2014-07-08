Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaGHCv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 22:51:29 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:57783 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaGHCv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 22:51:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVjjZaJLgKEOt5RQk4ikpeqxa=Sfqa6ew-7vmzn8jjDKyQ@mail.gmail.com>
References: <CAPDOMVgwJRj40p9FtnezoEmHLDYTJYQ8tDhZ_XyP7VOntFJF-Q@mail.gmail.com>
	<CAAsK9AEF2VGP-pvd+JodXb-6LERkSE1dRq_NUR4iLsiDs21chQ@mail.gmail.com>
	<CAPDOMViQOPB4qUetYiZLYan_SBVrycTPLHRcW3Y5BBkUZbRiWQ@mail.gmail.com>
	<CAPDOMVjjZaJLgKEOt5RQk4ikpeqxa=Sfqa6ew-7vmzn8jjDKyQ@mail.gmail.com>
Date: Mon, 7 Jul 2014 22:51:27 -0400
Message-ID: <CAPDOMVhYrAaq5skvxHfG0njNSWsSwG0A=o6P901-TdoATS2iGA@mail.gmail.com>
Subject: Fwd: Compiler Tests
From: Nick Krause <xerofoify@gmail.com>
To: Levente Kurusa <levex@linux.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Nick Krause <xerofoify@gmail.com>
Date: Mon, Jul 7, 2014 at 10:13 PM
Subject: Fwd: Compiler Tests
To: Levente Kurusa <levex@linux.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>


---------- Forwarded message ----------
From: Nick Krause <xerofoify@gmail.com>
Date: Mon, Jul 7, 2014 at 6:45 PM
Subject: Fwd: Compiler Tests
To: lkurusa@redhat.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>


On  Mon, Jul 7, 2014 at 4:31 PM Levente Kurusa wrote
Subject: Re: Compiler Tests
To: Nick Krause <xerofoify@gmail.com>
Hi,

2014-07-07 22:05 GMT+02:00 Nick Krause <xerofoify@gmail.com>:
> [...]
> um-i386: No compiler

UML should be able to be built without anything specific.

Try this:

$ make mrproper
$ make ARCH=um mrproper
$ make ARCH=um defconfig
$ make ARCH=um

... and then it should be built.



(Also, seeing from your other posts on the list, please avoid topposting...)

Thanks,
Levente Kurusa

Hey Levente,
Thanks for the information on um i386 build. I will build it later
today to see if it now builds.
Cheers Nick

Hey Levente,
um-i386 seems to  build now. Overall excluding rand configs we now
have as of updating my branch , 9 tests fail  as I am excluding xtensa
due
to issues with my binutils  perhaps.
Cheers Nick


Sorry again about another message but s390-allnoconfig seems to build
now which is great news. :)
Cheers Nick
