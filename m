Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3GDGJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 02:09:30 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56046 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab3GDGJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 02:09:29 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-15-51d51197834b
Message-id: <51D5118B.4000903@samsung.com>
Date: Thu, 04 Jul 2013 08:09:15 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620
 Thunderbird/17.0.7
MIME-version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] DMA-mapping updates for v3.11
References: <1372754108-21075-1-git-send-email-m.szyprowski@samsung.com>
 <20130703100903.81ab08c6db864c20498b558d@canb.auug.org.au>
 <51D3D9AD.9070800@samsung.com>
 <CA+55aFww7SG3BVDs5jUTwX9pjARG3XQXA2g_9XQJf6agq=fD9g@mail.gmail.com>
In-reply-to: <CA+55aFww7SG3BVDs5jUTwX9pjARG3XQXA2g_9XQJf6agq=fD9g@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t/xK7rTBa8GGlzZymJxedccNoute6+y
	Wzzqe8vuwOzReOMGm8eJGb9ZPD5vkgtgjuKySUnNySxLLdK3S+DK+P7zEEvBRaGKniPHWRoY
	z/J1MXJySAiYSLxcO48ZwhaTuHBvPVsXIxeHkMBSRonFt++CJYQEmpkk/nxzBbF5BbQk1q0/
	xApiswioSix4fJcRxGYTMJToetvFBmKLCoRKTFuygBGiXlDix+R7LCC2iICRxOcXV4B6OTiY
	BdIlOg6HgoSFBUwlTp/bCLXqLaPEo4c5IDanQLBEy68mJhCbWcBM4lHLOmYIW15i85q3zBMY
	BWYh2TALSdksJGULGJlXMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoSE6ZcdjIuPWR1iFOBg
	VOLhlbS6EijEmlhWXJl7iFGCg1lJhNeJ42qgEG9KYmVValF+fFFpTmrxIUYmDk6pBkbX514R
	FbvYt6dYdD6aX5Cg4Mxho6ry3yDw5cp1ghvVV/z0bDK8prPi2v2KeaG7rPlZF9xkZxDPX6Vm
	I31bUENiVek/85hnk3fNuX077mrkmxNz5B98vvSPeYV926e5HQxFi7R8p2y4qNtht8A9lvuD
	x5bT6xd9OL/v9orWlG1G9Z0XWTaKVB9QYinOSDTUYi4qTgQAEOd1uDECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 7/3/2013 11:02 PM, Linus Torvalds wrote:
> On Wed, Jul 3, 2013 at 12:58 AM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
> >
> > Right, I dropped one commit, which I found in other 'for_next' kernel tree
> > (the one from Russell King) before sending the pull request. What's wrong with
> > this approach?
>
> What did dropping the commit fix? Anything?
>
> DO NOT REBASE UNLESS YOU HAVE SERIOUSLY PRESSING REASONS!
>
> Why does this keep on coming up EVERY SINGLE RELEASE? Does nobody read my rants?
>
> A duplicate commit not a "seriously pressing reason". It may be reason
> for some introspection ("why did I and Russell end up applying the
> same patch and stepping on each others toes?") but it is not in itself
> at all a reason for rebasing.
>
> Reasons for rebasing include:
>
>   - "I am a complete moron, and I have terminally messed up my history
> with merges from random places to the point where it is completely
> unpullable"
>
>   - "There are commits that are so horribly broken in the history that
> I can't even revert them, because seeing them mentioned one more time
> will make me go blind"
>
> and the best one:
>
>   - "I never made my patches public in the first place, and I'll clean
> my ugly series up before posting them publicly for the first time".
>
> but that last one shouldn't happen just before sending it to me, it
> should happen a few weeks before sending to me so that linux-next has
> time to digest the beauty of the rebased series.
>
> The fact is, rebasing is a perfectly fine operation, but it's a fine
> operation that causes lots of problems if those commits have ever been
> public before. It means that linux-next cannot easily be compared to
> what I pull (which is why Stephen complains), but it also results in
> other developers not being able to trust your tree, and in the commits
> randomly changing and the testing base thus not being reliable any
> more (which is why I complain).

Ok, right. MY FAULT. I'm really sorry. I will never do it again.

Now, I want to repair what I broke. Do you want me to restore my tree to
the point before the rebase and send pull request again? The current tree
already appeared at next-20130703, so I wonder what would cause less harm
to others.

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland


