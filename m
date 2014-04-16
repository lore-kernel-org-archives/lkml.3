Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaDPIxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:53:06 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:32981 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaDPIxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:53:04 -0400
MIME-Version: 1.0
In-Reply-To: <201403312105.s2VL5AqX010173@terminus.zytor.com>
References: <201403312105.s2VL5AqX010173@terminus.zytor.com>
Date: Wed, 16 Apr 2014 14:23:02 +0530
X-Google-Sender-Auth: 1XlS1_WApy3DIsZiBditjlvgwdY
Message-ID: <CAOh2x=kq=fKSRV6XzZpiZCaBtKVAAcGRs6otBgxqgfQiXFu0ng@mail.gmail.com>
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>, ak@linux.intel.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>, gleb@redhat.com,
        hpa@zytor.com, hubicka@ucw.cz,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, pbonzini@redhat.com, perex@perex.cz,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 2:35 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> Andi Kleen (24):
>       Kbuild, lto: Drop .number postfixes in modpost

This generates a new warning with x86_64_defconfig atleast:

scripts/mod/modpost.c: In function 'remove_dot':
scripts/mod/modpost.c:1710:3: warning: ignoring return value of
'strtoul', declared with attribute warn_unused_result
[-Wunused-result]
