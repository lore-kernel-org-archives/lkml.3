Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129AbaHIEg6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 00:36:58 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:39425 "EHLO
	homiemail-a99.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798AbaHIEgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 00:36:55 -0400
X-Greylist: delayed 91885 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Aug 2014 00:36:55 EDT
From: =?utf-8?B?56mN5Li55bC8?= Dan Jacobson <jidanni@jidanni.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: disable "Call Trace:"
References: <877g2jznnt.fsf@jidanni.org>
Date: Sat, 09 Aug 2014 12:36:52 +0800
Message-ID: <87y4uyp9cr.fsf@jidanni.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "RD" == Randy Dunlap <rdunlap@infradead.org> writes:

RD> When would you want to disable it?  at kernel boot time (as a boot option)
RD> or sometime later?

RD> But would you only want to disable Call Trace: on panics or any time that a
RD> call trace might be printed?  and would disabling call trace also disable
RD> the raw stack dump and Code: output, or literally just the call trace?


All I know is e.g., somehow something went wrong and the user finds
himself unable to boot and unable to read the reason, as Linux is famous
for not having a way to scroll messages that have flown off the screen
and boot_delay= doesn't work good and he doesn't own another terminal he
can plug into a port or even have a port etc. etc. etc.


And he is sitting there and there is the reason, the main body of which
has just flown off the screen.


All pushed off due to this (useless to him) "Call Trace:" and some other
hex stuff lying above "Call Trace".


So if only he could please be able to, there hitting "e" in Grub,
be able to add so "call_trace=no_thanks" "other_hex_stuff=no_thanks"
to that linux command line, so then on the next run there will be
something more left upon the screen! Thank you!
