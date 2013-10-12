Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab3JLHHV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 03:07:21 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:34343 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3JLHHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 03:07:20 -0400
Message-ID: <5258F51B.4010203@synopsys.com>
Date: Sat, 12 Oct 2013 12:37:07 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        anton Kolesov <Anton.Kolesov@synopsys.com>
Subject: Re: [GIT PULL] ARC fix for 3.12.-rc5
References: <525799AC.4090201@synopsys.com> <CA+55aFyKrTi96duyjE5dhQLJBOrVUPEvPkQhwrfa=si+ez9bMQ@mail.gmail.com>
In-Reply-To: <CA+55aFyKrTi96duyjE5dhQLJBOrVUPEvPkQhwrfa=si+ez9bMQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.243]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 11:54 PM, Linus Torvalds wrote:
> On Thu, Oct 10, 2013 at 11:24 PM, Vineet Gupta
> <Vineet.Gupta1@synopsys.com> wrote:
>> The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:
>>
>>   Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/
> 
> Nothing there.
> 
> I'm *assuming* that you meant to point me at the "for-curr" branch,
> which does indeed contain the commit you talk about, but I want these
> things to be explicit rather than have to guess from your pull request
> and doing "git ls-remote".
> 
> Please fix your script.
> 
>            Linus
> 

Sorry about that - my newly minted script was indeed buggered.

Try below please.

Thx,
-Vineet
----------------->
The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

  Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/
tags/arc-fixes-for-3.12-part3

for you to fetch changes up to 5b24282846c064ee90d40fcb3a8f63b8e754fd28:

  ARC: Ignore ptrace SETREGSET request for synthetic register "stop_pc"
(2013-10-12 12:00:36 +0530)

----------------------------------------------------------------
Fix for broken gdb "jump"

----------------------------------------------------------------
Vineet Gupta (1):
      ARC: Ignore ptrace SETREGSET request for synthetic register "stop_pc"

 arch/arc/kernel/ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
