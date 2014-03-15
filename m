Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbaCOWVA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 18:21:00 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:54249 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbaCOWU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 18:20:58 -0400
Date: Sat, 15 Mar 2014 23:20:51 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1459598317.20140315232051@eikelenboom.it>
To: Peter Hurley <peter@hurleysoftware.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RC6 Bell Chime] [PATCH 00/24] rfcomm fixes
In-Reply-To: <5324BBCF.1090101@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com> <3E0F3723-029F-4B12-8D77-9790FDBD3227@holtmann.org> <1259174563.20140212120644@eikelenboom.it> <1335661753.20140303203853@eikelenboom.it> <1295963563.20140310093843@eikelenboom.it> <20140310150858.GA25703@tuxdriver.com> <EE67811F-FA2E-4773-8852-CB79BD7CDF1C@holtmann.org> <1679354302.20140314014901@eikelenboom.it> <53225B87.1030904@hurleysoftware.com> <164289036.20140315145146@eikelenboom.it> <CA+55aFzLGvLhF258vCWbyvXX0UOJ_tcnKaNRz_38mR5rnO6e_Q@mail.gmail.com> <5324BBCF.1090101@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Saturday, March 15, 2014, 9:45:03 PM, you wrote:

> On 03/15/2014 01:53 PM, Linus Torvalds wrote:
>> Guys, why is this being discussed?

> FWIW, the 'known breakage' for 3.14 is a (valid) lockdep report.

Hmm .. whoops you are right .. i remembered it as being an "oops",
but you are right it was merely an lockdep warning.
Should have checked that before putting up my big mouth .. sorry for that!

> This regression was introduced by a small patchset added to -next
> over the holidays that was intended to address 2 bug reports
> stemming from a long-overdue overhaul of the RFCOMM tty driver by
> Gianluca Anzolin (which fixed numerous problems and several hangs
> reported since 3.8).

Ok if what went in for 3.14 fixes some hangs that should probably outweigh
the lockdep warning regression.

> It is the bulk of that small patchset which is being reverted.

> The point of this brief history is that:
> 1) the 3.13 state of rfcomm is just as broken as 3.14-rcX, but
>     in a different way
> 2) there are plenty of serious defects in both versions regardless.

> I mean for this to be informative and not argumentative --
> either outcome is ok with me. In fact, I'm ok if you want to
> pick my entire 24-patch series that addresses the bugs in 3.13
> and 3.14, plus a bunch of other problems that I found at the time.

> Regards,
> Peter Hurley



