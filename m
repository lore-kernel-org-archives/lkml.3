Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaCHVCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 16:02:18 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:49500 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbaCHVCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 16:02:16 -0500
Message-ID: <1394312534.2040.18.camel@x220>
Subject: Re: [PATCH] [RESEND] score: remove unused CPU_SCORE7 Kconfig
 parameter
From: Paul Bolle <pebolle@tiscali.nl>
To: Lennox Wu <lennox.wu@gmail.com>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Sat, 08 Mar 2014 22:02:14 +0100
In-Reply-To: <CAF0htA7TeuKjQzU9EE5_RWUkznf+Xp=CsGd=TA6qB0COQxUYQg@mail.gmail.com>
References: <1386567192-19924-1-git-send-email-michael.opdenacker@free-electrons.com>
	 <1394256390-10603-1-git-send-email-michael.opdenacker@free-electrons.com>
	 <CAF0htA5OyL=cm7z5BMy1r7OcW_a-4WGEUbLzveR4fWgAC5av0Q@mail.gmail.com>
	 <1394308828.431.5.camel@x220>
	 <CAF0htA7TeuKjQzU9EE5_RWUkznf+Xp=CsGd=TA6qB0COQxUYQg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2014 21:02:15.0324 (UTC) FILETIME=[AEFB95C0:01CF3B11]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-09 at 04:27 +0800, Lennox Wu wrote:
> 2014-03-09 4:00 GMT+08:00 Paul Bolle <pebolle@tiscali.nl>:
> > In https://lkml.org/lkml/2011/11/12/76 I already reported that this
> > Kconfig symbol was unused. Why can't it be dropped and re-added when
> > code is added to the tree that actually uses it?
>
> Because I don't think droping it is meaningful, since it will be used.

But, again, it isn't used now and hasn't actually been used in years.

> Moreover, the symbol never affect other architectures or subsystems.
> I feel that is not good to brother people to process the unimportant patch.

Sure, this is just a small cleanup. But the scripts people use to see
whether more serious Kconfig related issues have entered the tree will
likely notice CPU_SCORE7. (And those people will have to investigate why
that symbol is unused - which might take quite a bit of work - to
determine what needs to be done about it.) So whenever someone, not
following this thread, runs a script like that the score maintainers
might receive a similar patch again.

And I don't believe that handling a single cleanup patch is particularly
burdensome for the score maintainers.


Paul Bolle

