Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaI0FuE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 01:50:04 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:56623 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaI0FuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 01:50:02 -0400
Date: Sat, 27 Sep 2014 07:49:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [GIT PULL] EFI urgent fixes
Message-ID: <20140927054956.GA719@gmail.com>
References: <20140925073133.GQ18635@console-pimps.org>
 <20140925144127.GA3828@gmail.com>
 <1411730854.7866.10.camel@x220>
 <20140926113510.GA14625@gmail.com>
 <20140926122405.GW18635@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926122405.GW18635@console-pimps.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> On Fri, 26 Sep, at 01:35:10PM, Ingo Molnar wrote:
> > 
> > A delta fix would be nice at this point, I've got the x86 side 
> > tested and besides this build bug it's ready to go to Linus.
> 
> Given that the typo doesn't result in an actual build failure, do you
> still want the following delta fix?

Ok, this one can indeed wait for the merge window - I'll send the 
other bits to Linus in a minute.

Thanks,

	Ingo
