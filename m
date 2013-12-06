Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab3LFOnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:43:42 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21261 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3LFOnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:43:41 -0500
Date: Fri, 6 Dec 2013 09:43:27 -0500
From: Dwight Engen <dwight.engen@oracle.com>
To: Kees Cook <keescook@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Ben Myers <bpm@sgi.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: XFS security fix never sent to -stable?
Message-ID: <20131206094327.0b0e22ef@oracle.com>
In-Reply-To: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
Organization: Oracle Corporation
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013 16:35:50 -0800
Kees Cook <keescook@google.com> wrote:

> Hi,
> 
> It looks like 8c567a7fab6e086a0284eee2db82348521e7120c ("xfs: add
> capability check to free eofblocks ioctl") is a security fix that was
> never sent to -stable? From what I can see, it was introduced in 3.8
> by 8ca149de80478441352a8622ea15fae7de703ced ("xfs: add
> XFS_IOC_FREE_EOFBLOCKS ioctl").
> 
> I don't see this in the 3.8.y tree. Should it be added there and
> newer?

I believe that would be appropriate, but would defer to Brian as the
original author of the eofblocks change.

> Thanks,
> 
> -Kees
> 

