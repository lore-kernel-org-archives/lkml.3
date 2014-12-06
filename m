Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaLFFK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 00:10:56 -0500
Received: from mail.wdtv.com ([66.118.69.84]:59391 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaLFFKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 00:10:55 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Dec 2014 00:10:54 EST
From: Gene Heskett <gheskett@wdtv.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: frequent lockups in 3.18rc4
Date: Sat, 6 Dec 2014 00:04:11 -0500
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?windows-1256?q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <547bbe36.48548c0a.105c.779c@mx.google.com> <20141205171501.GA1320@redhat.com> <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
In-Reply-To: <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201412060004.12469.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 December 2014, Linus Torvalds wrote:
>On Fri, Dec 5, 2014 at 9:15 AM, Dave Jones <davej@redhat.com> wrote:
>> A bisect later, and I landed on a kernel that ran for a day, before
>> spewing NMI messages, recovering, and then..
>> 
>> http://codemonkey.org.uk/junk/log.txt
>
>I have to admit I'm seeing absolutely nothing sensible in there.
>
>Call it bad, and see if bisection ends up slowly -oh so slowly -
>pointing to some direction. Because I don't think it's the hardware,
>considering that apparently 3.16 is solid. And the spews themselves
>are so incomprehensible that I'm not seeing any pattern what-so-ever.
>
>                     Linus

Sort of in the FWIW category, may not mean a thing.

I did find something in 3.16.0 that is troubling me at times, causing a 
very busy quad core Phenom.  But I have located the culprit in my case. 

Look at your Xorg.0.log. Because the nouveau bits in the 3.16.0 kernel I'm 
using are no longer 100% compatible with an Xorg install thats now 5 years 
old, I am generating Xorg.0.logs that can reach 500 megabyte or more in a 
couple weeks. I am trying to run down the latest Xorg I can build here on 
this *buntu 10.04.4 LTS box, but haven't located a URL to get the tarball 
from. Yet, its been busy here.

Cheers, Gene Heskett
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>
US V Castleman, SCOTUS, Mar 2014 is grounds for Impeaching SCOTUS
