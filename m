Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934409Ab3CZQpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:45:05 -0400
Received: from mout.gmx.net ([212.227.15.18]:56943 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934186Ab3CZQpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:45:03 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19f24la22pfD1bAd37NX0XkamuKXH4FMlIGqouElI
	LAhzJnr+ixdsB3
Message-ID: <5151D08A.2060400@gmx.de>
Date: Tue, 26 Mar 2013 17:44:58 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130309 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: user-mode-linux-user@lists.sourceforge.net,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: linux-v3.9-rc3: BUG: Bad page map in process trinity-child6 pte:002f9045
 pmd:29e421e1
References: <514C94C4.4050008@gmx.de> <20130325155347.75290358a6985e17fb10ad14@linux-foundation.org>
In-Reply-To: <20130325155347.75290358a6985e17fb10ad14@linux-foundation.org>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 11:53 PM, Andrew Morton wrote:
> On Fri, 22 Mar 2013 18:28:36 +0100 Toralf F__rster <toralf.foerster@gmx.de> wrote:
> 
>> > Using trinity I often trigger under a user mode linux image with host kernel 3.8.4
>> > and guest kernel linux-v3.9-rc3-244-g9217cbb the following :
>> > (The UML guest is a 32bit stable Gentoo Linux)
> I assume 3.8 is OK?
> 
With UML kernel 3.7.10 (host kernel still 3.8.4) I can trigger this
issue too.
Just to clarify it - here the bug appears in the UML kernel - the host
kernel is ok (I can of course crash a host kernel too by trinity'ing an
UML guest, but that's another thread - see [1])


FWIW he trinity command is just a test of 1 syscall:

$> trinity --children 1 --victims /mnt/nfs/n22/victims -c mremap



[1] https://lkml.org/lkml/2013/3/24/174

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
