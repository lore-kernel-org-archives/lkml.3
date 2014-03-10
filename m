Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbaCJBvI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 21:51:08 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:62857 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbaCJBvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 21:51:06 -0400
MIME-Version: 1.0
In-Reply-To: <201403100015.s2A0FM4Z015106@terminus.zytor.com>
References: <201403100015.s2A0FM4Z015106@terminus.zytor.com>
Date: Sun, 9 Mar 2014 18:51:05 -0700
X-Google-Sender-Auth: q2cFPYF9F-mcTHLoAHctigfgfFI
Message-ID: <CA+55aFx36NkGNSNdLfyrdFAv2s_Ay6wUCoh57H-XR0o+vzT2Fw@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes for v3.14-rc6 - bad patch dropped
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>, Russ Anderson <rja@sgi.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 9, 2014 at 5:15 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> The same collection of fixes except the broken NMI patch dropped.  I
> will send a fixed version of that plus Suresh' FPU fix in a few days,
> to get them some testing, plus I will be on a trip (part of why I got
> unduly rushed this past Friday.  Sorry again for that.)

I already pulled the broken one, and had actually pushed it out in
that broken format, which was so upsetting. Normally I tend to delay
pushing things out until I've done my compile tests, but I had
stupidly thought I didn't need to that time.

            Linus
