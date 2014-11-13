Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478AbaKMWre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:47:34 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:44133 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaKMWrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:47:33 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3292D57B@ORSMSX114.amr.corp.intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141112220058.GA5295@redhat.com> <CALCETrWA5z7-1fiz_9N0Qi2OR5s1jCkHiynCtTD_+9taOBs-Mg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BAB4@ORSMSX114.amr.corp.intel.com>
 <CALCETrU8uyc4nu-5MBXQR0PY0rexUhPkuPRLK+gWt0gEWMDhTA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BD44@ORSMSX114.amr.corp.intel.com>
 <CALCETrUpqSpcKFRM6a1zJWebEVZxNd-5pyBW4fU19+HgcBv+2Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292CB9A@ORSMSX114.amr.corp.intel.com>
 <CALCETrVx7hGZodWfAoU1oee1SW7XXSn3Lr8Vs9JTOUMNtLXY4A@mail.gmail.com> <3908561D78D1C84285E8C5FCA982C28F3292D57B@ORSMSX114.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Nov 2014 14:47:12 -0800
Message-ID: <CALCETrVB9VQPqFb7GQyxmVEKYtPhppmZS8SewQmtre+3_su9FA@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 2:33 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> Are you sure that this works in an unmodified kernel
>
> Unmodified kernel has run tens of thousands of injection/consumption/recovery cycles.
>
> I did get a crash with the entry/exit traces you asked for.  Last 20000 lines of console log
> attached.  There are a couple of OOPs before things fall apart completely.  I haven't yet
> counted all the entry/exits from the last cycle to see if they match.
>

That log was a good hint, and I am a fool.  I'll send a v3 once I test it.

I'm still unconvinced by the timeout code, though...

---Andy

> -Tony
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
