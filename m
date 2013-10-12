Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3JLUgv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 16:36:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38776 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab3JLUgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 16:36:51 -0400
Message-ID: <5259B29E.6000003@zytor.com>
Date: Sat, 12 Oct 2013 13:35:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
CC: Ingo Molnar <mingo@kernel.org>, Avi Kivity <avi@redhat.com>,
        Len Brown <len.brown@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
References: <20131012171553.GA17548@gmail.com>	<CA+55aFxFu9k7xOWd8DqXx8t+PONoV5ijGJv5mshZrYeVsVp32w@mail.gmail.com>	<820c2fd2311341ce8a9b59e621c3fd1f@BY2PR05MB222.namprd05.prod.outlook.com> <CA+55aFz2b_HYRuATpquNEo1yD=iWLJmCQAJ2pxYcsePjpY+CiQ@mail.gmail.com>
In-Reply-To: <CA+55aFz2b_HYRuATpquNEo1yD=iWLJmCQAJ2pxYcsePjpY+CiQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2013 12:41 PM, Linus Torvalds wrote:
> On Sat, Oct 12, 2013 at 12:28 PM, Matthew Garrett
> <matthew.garrett@nebula.com> wrote:
>>
>> The most likely cause of the problem that we're seeing here is that we're leaving the hardware in a state that isn't compatible with assumptions made by Dell's SMM code. We've certainly seen that some previous Dell machines have made incorrect assumptions about VT-d, which probably means that we should be destroying that state before reboot. David Woodhouse had been looking into that - I don't know whether we ever actually merged anything to do so.
> 
> I have access to one of the affected Dell systems, so I'm willing to
> try patches..
> 

The Dell machines definitely use some kind of SMM to reboot.

	-hpa


