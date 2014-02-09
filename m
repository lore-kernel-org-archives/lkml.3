Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaBIWlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 17:41:49 -0500
Received: from mail.wdtv.com ([66.118.69.84]:44822 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbaBIWls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 17:41:48 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 24/28] Remove DEPRECATED
Date: Sun, 9 Feb 2014 17:41:46 -0500
Cc: Richard Weinberger <richard@nod.at>, Guenter Roeck <linux@roeck-us.net>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        "moderated list:PANASONIC MN10300..." <linux-am33-list@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1391971686-9517-1-git-send-email-richard@nod.at> <201402091654.25697.gheskett@wdtv.com> <1391983888.25855.73.camel@x220>
In-Reply-To: <1391983888.25855.73.camel@x220>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201402091741.46390.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 February 2014, Paul Bolle wrote:
>On Sun, 2014-02-09 at 16:54 -0500, Gene Heskett wrote:
>> And much of it is in a bad make oldconfig that I can't date, but all of
>> the multimedia stuff has been stripped and I can no longer use my
>> pcHDTV3000 card as just one for instance.  I just tested it, using an
>> oldconfig that contained several hundred bits and pieces under the
>> ATSC & DVB headers, after the oldconfig was done, all that was
>> stripped from the new one, every trace of it.  That was working code
>> guys, what the hell?  Kconfig could have problems, but the oldconfig
>> output being stripped is a much larger one.  First problems first. 
>> Then you can really see how fubared kconfig is.
>
>What has this got to do with an invalid Kconfig dependency in
>arch/mn10300?
>
>
>Paul Bolle

Probably not much Paul,I was trying to point out a much bigger problem for 
many of us at least on the x86 machinery, who seem to have accepted that 
support of their machinery has now apparently been deprecated, by something 
in the make oldconfig region.  The arch/mn10300 problem is completely lost 
in the noise of this breakage to the x86 people.  And I dare say there are 
more of us by a factor of at least 100.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

