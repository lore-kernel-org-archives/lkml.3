Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaBIVya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 16:54:30 -0500
Received: from mail.wdtv.com ([66.118.69.84]:48815 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbaBIVy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 16:54:27 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 24/28] Remove DEPRECATED
Date: Sun, 9 Feb 2014 16:54:25 -0500
Cc: Guenter Roeck <linux@roeck-us.net>, Paul Bolle <pebolle@tiscali.nl>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        "moderated list:PANASONIC MN10300..." <linux-am33-list@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1391971686-9517-1-git-send-email-richard@nod.at> <52F7F486.7040003@roeck-us.net> <52F7F54B.3050602@nod.at>
In-Reply-To: <52F7F54B.3050602@nod.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201402091654.25697.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 February 2014, Richard Weinberger wrote:
>Am 09.02.2014 22:35, schrieb Guenter Roeck:
>> I could understand if you would replace DEPRECATED with BROKEN,
>> but causing a potentially large number of broken builds and
>> then leave it to others to clean up the resulting mess doesn't
>> make any sense to me and should, in my opinion, be rejected.
>
>Currently the mess is hidden by bad Kconfig dependencies.
>We have to face it. :)

And much of it is in a bad make oldconfig that I can't date, but all of the 
multimedia stuff has been stripped and I can no longer use my pcHDTV3000 
card as just one for instance.  I just tested it, using an oldconfig that 
contained several hundred bits and pieces under the ATSC & DVB headers,  
after the oldconfig was done, all that was stripped from the new one, every 
trace of it.  That was working code guys, what the hell?  Kconfig could 
have problems, but the oldconfig output being stripped is a much larger 
one.  First problems first.  Then you can really see how fubared kconfig 
is.

>Of course, if the maintainer wants me or Paul to remove the resulting
>mess to I'm fine with that...
>
>Thanks,
>//richard
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>in the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/


Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

