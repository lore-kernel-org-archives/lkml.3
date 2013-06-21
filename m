Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161594Ab3FUQkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:40:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58041 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161494Ab3FUQkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:40:40 -0400
Message-ID: <51C481CD.1080909@zytor.com>
Date: Fri, 21 Jun 2013 09:39:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Joshua Covington <joshuacov@googlemail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] x86 fixes for v3.10-rc7
References: <201306210055.r5L0tNKi027615@terminus.zytor.com> <CA+55aFyKrJ36fLeR_F2=CWh1aAMXUxOcz9Qd3rc8SjQ-caXyBg@mail.gmail.com>
In-Reply-To: <CA+55aFyKrJ36fLeR_F2=CWh1aAMXUxOcz9Qd3rc8SjQ-caXyBg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 09:37 AM, Linus Torvalds wrote:
> On Thu, Jun 20, 2013 at 2:55 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>
>> This series fixes a couple of build failures, and fixes MTRR cleanup
>> and memory setup on very specific memory maps.  Finally, it fixes
>> triggering backtraces on all CPUs, which was inadvertently disabled on
>> x86.
> 
> Hmm. You also just snuck an EFI fix in there after the pull request,
> without sending an update email. Tssk.
> 

Argh.  The script put the wrong branch name in the pull request
(x86/urgent instead of x86-urgent-for-linus).  I *was* going to update
the branch and send a new email today, after having Ingo's test machine
run it a bit.

Anyway, if you pulled it, no reason to unpull...

	-hpa


