Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab3ANRuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:50:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55477 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297Ab3ANRuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:50:23 -0500
Message-ID: <50F4452D.2060000@zytor.com>
Date: Mon, 14 Jan 2013 09:49:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Subject: Re: [PATCH v7u1 22/31] x86, boot: add fields to support load bzImage
 and ramdisk above 4G
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org> <1357260531-11115-23-git-send-email-yinghai@kernel.org> <20130113214132.GB17200@liondog.tnic> <CAE9FiQVQRAOtw7kiPJO3xszJx9uPFjgK82PjbvTyqzJgujdicw@mail.gmail.com>
In-Reply-To: <CAE9FiQVQRAOtw7kiPJO3xszJx9uPFjgK82PjbvTyqzJgujdicw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2013 09:37 PM, Yinghai Lu wrote:
>>
>> This is kinda missing from the mechanism of the sentinel and it should
>> be documented too.
>
> No, we should have too much duplicated info.
>

That is not duplicating info... that is basic documentation.  As you 
show in the post further on, it took a very simple description, and it 
*is* a very subtle thing that is inherently different from how the other 
fields operate.

It doesn't help that you didn't, despite repeated requests, implement 
what I *asked for*, which is:

If the sentinel is flagged, zero *all fields not explicitly set by the 
broken versions of kexec*, not just your new "ext" fields.

Yinghai, I understand you're frustrated, but please understand that 
Borislav is not in any shape, way, or form "some guys that do not know 
the code well keep sending comments out to waste others time".  Rather, 
he has spent a huge amount of time giving you an awful lot of good 
feedback  A lot of them have centered on documentation and code 
maintainability, both of which are vitally important part of a 
long-lived codebase.

Having someone doing line-by-line review of your code is enormously 
time-consuming and not something most people enjoy doing.  Borislav is 
doing you -- and me -- a huge favor here.

	-hpa



-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

