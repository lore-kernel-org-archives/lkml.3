Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab3IBSjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 14:39:54 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:46089 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758818Ab3IBSjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 14:39:52 -0400
X-AuditID: cbfec372-b7fe76d000003347-a2-5224db770af2
Date: Mon, 02 Sep 2013 15:39:45 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
Message-id: <20130902153945.6d7e510c@samsung.com>
In-reply-to: <20130902181856.GB29787@leaf>
References: <9976.1378132260@warthog.procyon.org.uk>
 <1378138205.1953.66.camel@joe-AO722> <20130902181510.GA29787@leaf>
 <20130902181856.GB29787@leaf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/hQN3y2ypBBu0/mSw+rNWwmH3/MYvF
	/wX5Frd+zGWyuLxrDpvFo7637A5sHrMaetk8br229Tgx4zeLx+8fkxk9vqy6xuzxeZNcAFsU
	l01Kak5mWWqRvl0CV8bDFd3sBZu4K6bd/M/UwDiDs4uRk0NCwETiaNNGdghbTOLCvfVsXYxc
	HEICSxgljp1dzALhdDNJTP/+nBmkikVAVWLhob2sIDabgJHEq8YWIJuDQ0RAU2L6ZiWQemaB
	k4wSK/v3s4HUCAvkSXRMWwS2gVfAUKJl0z2wOZwCWhL3mmawQyyYyShxsOEpC8ggCQEnia1T
	fSHqBSV+TL7HAmIzA9Vv3tbECmHLS2xe85Z5AqPALCRls5CUzUJStoCReRWjaGlxckFxUnqu
	oV5xYm5xaV66XnJ+7iZGSIAX7WB8tsHqEKMAB6MSDy/HXpUgIdbEsuLK3EOMEhzMSiK8vycD
	hXhTEiurUovy44tKc1KLDzEycXBKNTDulTHKOb92+d6Q3ooluVXlAZJ/tmhfu8SyO9lwRbtp
	+Z+M1+bf7U7YaSvduBir2P7pfXX+qQMfa0umON0L/PK3YlO0/6YjvpU3Z6zMLr3Ofundg6jw
	Hy0H1xQx7iq2eVv+aVWE0jzDfRklO38+K9iTlJy/Pu2Xlf7TpxJ8z7s7zkmbTMmZxfZAiaU4
	I9FQi7moOBEAFNpabk4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 2 Sep 2013 11:19:01 -0700
Josh Triplett <josh@joshtriplett.org> escreveu:

> Patches to checkpatch that add new style rules should also change
> Documentation/CodingStyle to document those new style rules; add a
> comment to that effect to the top of scripts/checkpatch.pl.

Well, you forgot to c/c LKML on this patch; I think that KS2013 is not the
proper list to review this patch ;)

> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  scripts/checkpatch.pl | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 2ee9eb7..ba65ea6 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -4,6 +4,10 @@
>  # (c) 2007,2008, Andy Whitcroft <apw@uk.ibm.com> (new conditions, test suite)
>  # (c) 2008-2010 Andy Whitcroft <apw@canonical.com>
>  # Licensed under the terms of the GNU GPL License version 2
> +#
> +# This file does not define the kernel coding style; Documentation/CodingStyle
> +# does.  If you add a new style test to this file, add the corresponding style
> +# rule it enforces to Documentation/CodingStyle.
>  

Agreed with that. I would also add another comment there: "in case of
conflicts between checkpatch.pl and Documentation/CodingStyle, the latter
takes precedence."

Anyway,

Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

>  use strict;
>  use POSIX;

Regard
-- 

Cheers,
Mauro
