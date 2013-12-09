Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab3LIMPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 07:15:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35198 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab3LIMPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 07:15:40 -0500
Date: Mon, 9 Dec 2013 12:15:34 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Kees Cook <keescook@google.com>
Cc: Dwight Engen <dwight.engen@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Ben Myers <bpm@sgi.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: XFS security fix never sent to -stable?
Message-ID: <20131209121534.GE4278@hercules>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 04:35:50PM -0800, Kees Cook wrote:
> Hi,
> 
> It looks like 8c567a7fab6e086a0284eee2db82348521e7120c ("xfs: add
> capability check to free eofblocks ioctl") is a security fix that was
> never sent to -stable? From what I can see, it was introduced in 3.8
> by 8ca149de80478441352a8622ea15fae7de703ced ("xfs: add
> XFS_IOC_FREE_EOFBLOCKS ioctl").
> 
> I don't see this in the 3.8.y tree. Should it be added there and newer?

Thanks Kees, I'm queuing it for the 3.11 kernel.

Cheers,
--
Luis
