Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3LFAfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:35:53 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:49414 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3LFAfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:35:51 -0500
MIME-Version: 1.0
Date: Thu, 5 Dec 2013 16:35:50 -0800
Message-ID: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
Subject: XFS security fix never sent to -stable?
From: Kees Cook <keescook@google.com>
To: Dwight Engen <dwight.engen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Ben Myers <bpm@sgi.com>, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It looks like 8c567a7fab6e086a0284eee2db82348521e7120c ("xfs: add
capability check to free eofblocks ioctl") is a security fix that was
never sent to -stable? From what I can see, it was introduced in 3.8
by 8ca149de80478441352a8622ea15fae7de703ced ("xfs: add
XFS_IOC_FREE_EOFBLOCKS ioctl").

I don't see this in the 3.8.y tree. Should it be added there and newer?

Thanks,

-Kees

-- 
Kees Cook
Chrome OS Security
