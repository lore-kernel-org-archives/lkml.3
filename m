Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaIZMee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:34:34 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:60204 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaIZMec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:34:32 -0400
Date: Fri, 26 Sep 2014 13:34:29 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [GIT PULL] EFI urgent fixes
Message-ID: <20140926123429.GX18635@console-pimps.org>
References: <20140925073133.GQ18635@console-pimps.org>
 <20140925144127.GA3828@gmail.com>
 <1411730854.7866.10.camel@x220>
 <20140926114454.GV18635@console-pimps.org>
 <1411732755.7866.24.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411732755.7866.24.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep, at 01:59:15PM, Paul Bolle wrote:
> 
> I have a 800 line perl monster that checks for stuff like this. It's not
> very sophisticated but smart enough to spot typos like this one. I try
> to have it check each linux-next (and mainline) release.
 
Very cool.

> (I think Valentin Rothberg is trying to automate this properly. See
> http://www.linuxplumbersconf.org/2014/ocw/sessions/1863 .)

Have either of you guys thought about asking for this to be included
with the 0-day kbuild bot or submitted under scripts/?

It certainly seems like a useful bit of functionality.

Fengguang, the interesting bits of this thread start here,

  https://lkml.kernel.org/r/1411730854.7866.10.camel@x220

-- 
Matt Fleming, Intel Open Source Technology Center
