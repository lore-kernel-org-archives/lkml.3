Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbaGOWss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:48:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:59690 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817AbaGOWsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:48:41 -0400
Message-ID: <53C5AFC3.7000908@infradead.org>
Date: Tue, 15 Jul 2014 15:48:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, sfr@canb.auug.org.au,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-doc <linux-doc@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: make mandocs fails with next-20140715
References: <CA+r1Zhg9wwv6qUcRMWNBadE=dWFjbb45J+SwRpV7xg8AmgSEpw@mail.gmail.com>
In-Reply-To: <CA+r1Zhg9wwv6qUcRMWNBadE=dWFjbb45J+SwRpV7xg8AmgSEpw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/14 14:15, Jim Davis wrote:
> jim@krebstar:~/linux2$ make mandocs
>   HOSTCC  scripts/basic/fixdep
>   HOSTCC  scripts/docproc
>   DOCPROC Documentation/DocBook/z8530book.xml
>   MAN     Documentation/DocBook/z8530book.9
> Warn: AUTHOR sect.: no personblurb|contrib for Alan Cox
> 
> [... ]
> 
> Note: Writing spans_boundary.9
>   DOCPROC Documentation/DocBook/device-drivers.xml
> docproc: .//kernel/timer.c: No such file or directory
> make[1]: *** [Documentation/DocBook/device-drivers.xml] Error 1
> make: *** [mandocs] Error 2

IIRC Thomas has a patch for this.  Thomas, is the patch in your linux-next tree
or branch or leaf?

-- 
~Randy
