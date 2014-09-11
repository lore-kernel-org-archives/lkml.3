Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbaIKOM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:12:29 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:39211 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbaIKOM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:12:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUvBdEKCYezARJ8PvuQPQbi+Wq-fwO+Z2cxYXOtVzp5GQ@mail.gmail.com>
References: <20140908181524.GA11839@www.outflux.net>
	<20140910155219.3d21aef2df8b1754a736cc1a@linux-foundation.org>
	<CAMuHMdUvBdEKCYezARJ8PvuQPQbi+Wq-fwO+Z2cxYXOtVzp5GQ@mail.gmail.com>
Date: Thu, 11 Sep 2014 07:12:24 -0700
X-Google-Sender-Auth: QBUW1g11vfH6l9fYejXgNXMDoMw
Message-ID: <CAGXu5jKndemuqx=uFXSSEgD9v2U4b4E8Eh6O=FFNw+GL7fixxA@mail.gmail.com>
Subject: Re: [PATCH v2] checkpatch: look for common misspellings
From: Kees Cook <keescook@chromium.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Masanari Iida <standby24x7@gmail.com>,
        linux-doc <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 12:19 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Thu, Sep 11, 2014 at 12:52 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Mon, 8 Sep 2014 11:15:24 -0700 Kees Cook <keescook@chromium.org> wrote:
>>
>>> Check for misspellings, based on Debian's lintian list. Several false
>>> positives were removed, and several additional words added that were
>>> common in the kernel:
>>>
>>>       backword backwords
>>>       invalide valide
>>>       recieves
>>>       singed unsinged
>>>
>>> While going back and fixing existing spelling mistakes isn't a high
>>> priority, it'd be nice to try to catch them before they hit the tree.
>>
>> I have a feeling this is going to be a rat hole and that
>> scripts/spelling.txt will grow to consume the planet.  Oh well, whatev.
>
> What about making checkpatch use the codespell dictionay if codespell
> is installed?
>
> Codespell is in Ubuntu 14.04LTS (but not in 12.04LTS).

It's probably not a bad idea, but given the level of pruning that's
been needed already to keep down the false positive rate, I'm nervous
about a larger "general" corpus.

-Kees

-- 
Kees Cook
Chrome OS Security
