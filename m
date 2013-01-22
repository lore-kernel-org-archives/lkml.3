Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3AVLfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:35:21 -0500
Received: from multi.imgtec.com ([194.200.65.239]:2174 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab3AVLfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:35:15 -0500
Message-ID: <50FE796D.5070608@imgtec.com>
Date: Tue, 22 Jan 2013 11:35:09 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v3 00/44] Meta Linux Kernel Port
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <20130111103442.b80ddbfb11ef322ed28ca3b3@canb.auug.org.au> <50EFD824.3010502@imgtec.com> <20130112000336.1f24c42237fab4fe0c305ff6@canb.auug.org.au> <50F0296E.2000704@imgtec.com> <20130112120957.36df3412c9d6cca089a0340a@canb.auug.org.au> <20130112095507.GA1738@balrog> <20130119055501.GA2802@ZenIV.linux.org.uk>
In-Reply-To: <20130119055501.GA2802@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_22_11_35_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/01/13 05:55, Al Viro wrote:
> On Sat, Jan 12, 2013 at 09:55:07AM +0000, James Hogan wrote:
>> Hi Stephen, Al,
>>
>> On Sat, Jan 12, 2013 at 12:09:57PM +1100, Stephen Rothwell wrote:
>>> On Fri, 11 Jan 2013 15:02:06 +0000 James Hogan <james.hogan@imgtec.com> wrote:
>>>>
>>>> Okay, I've rebased the metag tree from linux-next onto the master branch
>>>> of Al's signal tree (to get Vineet's GENERIC_SIGALTSTACK fix and
>>>> GENERIC_SIGALTSTACK's eventual removal).
>>>
>>> OK, but I hope you mentioned not rebasing to Al.
>>
>> I'm still rebasing the metag tree, and it's not quite ready for -next so
>> I don't mind if Al's tree rebases at this stage tbh.
>>
>> Al: I don't know if you normally rebase your tree, but if it's okay with
>> you I'll let you know when I need it not to be rebased.
> 
> Umm...  
> 	1) #master is definitely bad for base; #for-linus is much safer (and
> sufficient for your case)

Thanks for that, and I see it's now merged into Linus' tree so I'll
rebase onto that instead.

Cheers
James

