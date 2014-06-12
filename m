Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaFLUal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:30:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37251 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbaFLUaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:30:39 -0400
Message-ID: <539A0DC2.1010203@zytor.com>
Date: Thu, 12 Jun 2014 13:29:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/2] make kASLR vs hibernation boot-time selectable
References: <1402602419-27934-1-git-send-email-keescook@chromium.org>	<539A0422.9010000@zytor.com> <CAGXu5jLvAr=f2MRP4Ni86-jbM7h3Mx3RQo=7coveE8ZEt12N=Q@mail.gmail.com>
In-Reply-To: <CAGXu5jLvAr=f2MRP4Ni86-jbM7h3Mx3RQo=7coveE8ZEt12N=Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 01:27 PM, Kees Cook wrote:
>>
>> Any way we can make them work together instead?
> 
> I'm sure there is, but I don't know the solution. :)
> 
> At the very least this gets us one step closer (we can build them together).
> 

But it is really invasive.

I have to admit to being somewhat fuzzy on what the core problem with
hibernation and kASLR is... in both cases there is a set of pages that
need to be installed, some of which will overlap the loader kernel.
What am I missing?

	-hpa


