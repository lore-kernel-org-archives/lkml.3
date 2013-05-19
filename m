Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3ESNp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 09:45:57 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:49656 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab3ESNpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 09:45:55 -0400
Date: Sun, 19 May 2013 09:45:48 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jonas Gorski <jonas.gorski+gpl@gmail.com>
Cc: "luke.leighton" <luke.leighton@gmail.com>,
        Cole Johnson <coleharrisjohnson@gmail.com>,
        legal@lists.gpl-violations.org, linux-kernel@vger.kernel.org
Subject: Re: Would like to form a pool of Linux copyright holders for faster
 GPL enforcement against Anthrax Kernels
Message-ID: <20130519134548.GA7183@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jonas Gorski <jonas.gorski+gpl@gmail.com>,
	"luke.leighton" <luke.leighton@gmail.com>,
	Cole Johnson <coleharrisjohnson@gmail.com>,
	legal@lists.gpl-violations.org, linux-kernel@vger.kernel.org
References: <CAPweEDxgT+ZygfPZDd8YePe7RurTU7o_UtiBqjUvCMimChpTug@mail.gmail.com>
 <1368918189923.dd7325ed@Nodemailer>
 <CAPweEDwYm6iQ1vJ_UwAC5pE-uwfnMDHR6wJ1VppW1wakmTMJGQ@mail.gmail.com>
 <CAOiHx=ksyGWYZhafde_5NqUf1wpyWKNc3rs5heFHsNKD8GhXGQ@mail.gmail.com>
 <CAPweEDzsCf3rQB_hZ2=OH_b8McYRY7VUit=j-1=aVSd7vbM+og@mail.gmail.com>
 <CAOiHx=nh5dBSEHL06mH-e4YGn7TCSaaBuOQU=JBJcnxQUWLBDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOiHx=nh5dBSEHL06mH-e4YGn7TCSaaBuOQU=JBJcnxQUWLBDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 19, 2013 at 03:28:28PM +0200, Jonas Gorski wrote:
> Because Linus /is/ the highest authority regarding Linux. He holds the
> copyright to the most crucial parts, and without his cooperation, you
> will never get the GPLv2 parts to be re-licensed to GPLv2+, unless you
> remove everything from him and replace it with your own
> implementations. And do the same with every other contributors' code
> who doesn't agree to switch to GPLv2+.

It's not just Linus; many senior Linux kernel developers have spoken
very clearly that the anti-Tivoization clause in GPLv3 is totally
unacceptable, and so many of us have stated unequivocally that our
code will be released under a GPLv2-only license.  This means that
GPLv3-only code is always going to be incompatible with code released
as part of the Linux kernel, because substantial parts of the kernel
have and will be available only under a GPLv2 only license.

If anyone wants to release their code under a dual-license, it's
easist if that's how you submitted the code originally.  For example,
drivers/char/random.c is released under a BSD/GPLv2 dual license
(because I wanted to encourage its use in other operating systems,
since to me high quality crypto is more important that free software
wankery/idealism).

If you have only contributed a few lines or partially to a particular
single file, specifying that "these 15 linues of the function
I_worship_at_the_altar_of_rms() are under the GPLv2/v3, even through
the rest of the file is GPLv2-only" is not something that we generally
do.  Speaking as a subsystem maintainer, for the portions of the code
that I maintain, if someone insisted on line-level copyright
statements, I'd just simply reject the patch rather than dealing with
the accounting nightmare.

If you want to add a GPLv2/GPLv3 dual license to a file which you
originally contributed to, but then later on other peoeple have
contributed lines of code, you'll need to get the consent of everyone
who have contributed changes to that file.

Finally, as Jonas has stated, if you are trying to impose the
anti-Tivoization clause through the back door, it's not going to have
that effect, since people can always choose either license for
dual-licensed code, and for the kernel GPLv2 always has to be one of
the choices.  The only reason why you might want to dual-license the
code is if you want to allow said code to be used in other contexts,
either in BSD-licensed code in the case of a GPLv2/BSD dual license,
or GPLv3-only licensed code in the case of a GPLv2/GPLv3 dual license.

Regards,

						- Ted
