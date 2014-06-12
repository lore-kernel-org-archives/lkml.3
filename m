Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaFLU1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:27:14 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:55925 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbaFLU1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:27:12 -0400
MIME-Version: 1.0
In-Reply-To: <539A0422.9010000@zytor.com>
References: <1402602419-27934-1-git-send-email-keescook@chromium.org>
	<539A0422.9010000@zytor.com>
Date: Thu, 12 Jun 2014 13:27:11 -0700
X-Google-Sender-Auth: engsWs6iF5c_z16AE_cyXSSXLbY
Message-ID: <CAGXu5jLvAr=f2MRP4Ni86-jbM7h3Mx3RQo=7coveE8ZEt12N=Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] make kASLR vs hibernation boot-time selectable
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 12:48 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/12/2014 12:46 PM, Kees Cook wrote:
>> Distros want to be able to offer CONFIG_RANDOMIZE_BASE as well as
>> CONFIG_HIBERNATION in a single kernel. Instead of making kASLR depend on
>> !HIBERNATION at compile time, allow kaslr to be selectable at boot time
>> (via "kaslr" kernel command line), which will disable hibernation in the
>> kernel. In this way the end user can choose which feature they want more
>> with hibernation continuing to stay enabled by default (no surprises).
>
> Any way we can make them work together instead?

I'm sure there is, but I don't know the solution. :)

At the very least this gets us one step closer (we can build them together).

-Kees

-- 
Kees Cook
Chrome OS Security
