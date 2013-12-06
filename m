Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161097Ab3LFPGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:06:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab3LFPGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:06:32 -0500
Message-ID: <52A1E7E9.8020904@redhat.com>
Date: Fri, 06 Dec 2013 10:06:17 -0500
From: Brian Foster <bfoster@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dwight Engen <dwight.engen@oracle.com>, Kees Cook <keescook@google.com>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, Ben Myers <bpm@sgi.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: XFS security fix never sent to -stable?
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com> <20131206094327.0b0e22ef@oracle.com>
In-Reply-To: <20131206094327.0b0e22ef@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 09:43 AM, Dwight Engen wrote:
> On Thu, 5 Dec 2013 16:35:50 -0800
> Kees Cook <keescook@google.com> wrote:
> 
>> Hi,
>>
>> It looks like 8c567a7fab6e086a0284eee2db82348521e7120c ("xfs: add
>> capability check to free eofblocks ioctl") is a security fix that was
>> never sent to -stable? From what I can see, it was introduced in 3.8
>> by 8ca149de80478441352a8622ea15fae7de703ced ("xfs: add
>> XFS_IOC_FREE_EOFBLOCKS ioctl").
>>
>> I don't see this in the 3.8.y tree. Should it be added there and
>> newer?
> 
> I believe that would be appropriate, but would defer to Brian as the
> original author of the eofblocks change.
> 

I have no objection to proposing this for stable. The fix is
straightforward and isolated enough.

Brian

>> Thanks,
>>
>> -Kees
>>
> 

