Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaILKaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:30:19 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35338 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaILKaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:30:16 -0400
MIME-Version: 1.0
In-Reply-To: <1410497111.9942.26.camel@joe-AO725>
References: <20140908181524.GA11839@www.outflux.net>
	<20140910155219.3d21aef2df8b1754a736cc1a@linux-foundation.org>
	<CAMuHMdUvBdEKCYezARJ8PvuQPQbi+Wq-fwO+Z2cxYXOtVzp5GQ@mail.gmail.com>
	<1410444957.9942.3.camel@joe-AO725>
	<CALLJCT1_pB8pEHCCEnNzfQrRR16dGD3rdfjAt40sHXzTBbdEXQ@mail.gmail.com>
	<1410497111.9942.26.camel@joe-AO725>
Date: Fri, 12 Sep 2014 19:30:13 +0900
Message-ID: <CALLJCT36JzRDkkTSqddSDJJPWrMGRhTUhOSd=pcJCAAX4sCBRQ@mail.gmail.com>
Subject: Re: [PATCH v2] checkpatch: look for common misspellings
From: Masanari Iida <standby24x7@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        linux-doc <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 1:45 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2014-09-12 at 13:09 +0900, Masanari Iida wrote:
>> Test with "reseting" case,  codespell found 21, grep found 26.
>
> Hello Masanari.
>
> How did codespell find any uses of reseting?
> What version of codespell are you using?
> (I tested with 1.7)
>
> Looking at the git tree for codespell,
> https://github.com/lucasdemarchi/codespell.git
> the dictionary there doesn't have reseting.
>
Joe,

First of all, I use codespell 1.4 scripts with my original dictionary
based on 1.4.
So I believe the "reseting" was added by me some times ago.

> If I add reseting->resetting to the dictionary,
> then codespell finds the same 31 uses that
> git grep -i does.
>
My codespell 1.4 works as case sensitive.
That's why we saw a little bit different result.

Masanari
