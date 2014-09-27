Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaI0INd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 04:13:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48730 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaI0INW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 04:13:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140926123429.GX18635@console-pimps.org>
References: <20140925073133.GQ18635@console-pimps.org> <20140925144127.GA3828@gmail.com>
 <1411730854.7866.10.camel@x220> <20140926114454.GV18635@console-pimps.org>
 <1411732755.7866.24.camel@x220> <20140926123429.GX18635@console-pimps.org>
From: Valentin Rothberg <valentinrothberg@gmail.com>
Date: Sat, 27 Sep 2014 10:04:42 +0200
Message-ID: <CAD3Xx4JmkDZ1Cw02DFAE0fa0EaEmBi8-W-p7JCfEXLERK5yuUQ@mail.gmail.com>
Subject: Re: [GIT PULL] EFI urgent fixes
To: Matt Fleming <matt@console-pimps.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 2:34 PM, Matt Fleming <matt@console-pimps.org> wrote:
> On Fri, 26 Sep, at 01:59:15PM, Paul Bolle wrote:
>>
>> I have a 800 line perl monster that checks for stuff like this. It's not
>> very sophisticated but smart enough to spot typos like this one. I try
>> to have it check each linux-next (and mainline) release.
>
> Very cool.
>
>> (I think Valentin Rothberg is trying to automate this properly. See
>> http://www.linuxplumbersconf.org/2014/ocw/sessions/1863 .)
>
> Have either of you guys thought about asking for this to be included
> with the 0-day kbuild bot or submitted under scripts/?
>
> It certainly seems like a useful bit of functionality.

Yes, I was talking with Greg about including the tool in the 0-day
testing. In addition, I am working on a  patch to change the
scripts/checkkconfigsymbols script
(https://lkml.org/lkml/2014/9/22/336).

The mayor difference between my tool and the script is that the script
can only find bugs on a symbolic level (i.e., a reference on an
feature that is not defined in Kconfig). The tool that I will present
at the Plumbers Conference is additionally able to detect issue on the
logic level, for instance an #ifdef block that can never be compiled
as its precondition is contradictory. I will send some patches the
next weeks to show which bugs can be detected with the tool.

> Fengguang, the interesting bits of this thread start here,
>
>   https://lkml.kernel.org/r/1411730854.7866.10.camel@x220
>
> --
> Matt Fleming, Intel Open Source Technology Center
