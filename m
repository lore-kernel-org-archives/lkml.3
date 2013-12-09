Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719Ab3LINRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:17:13 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:57632 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab3LINRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:17:10 -0500
MIME-Version: 1.0
In-Reply-To: <20131209121534.GE4278@hercules>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
	<20131209121534.GE4278@hercules>
Date: Mon, 9 Dec 2013 08:17:09 -0500
X-Google-Sender-Auth: c48Lbza-jTqcuZ7byi6yCH-PuZw
Message-ID: <CA+5PVA4ychvLEi1ZZ6rYy2=5-wZAbQ_a-aoy8=1w3+tr-pt3Fg@mail.gmail.com>
Subject: Re: XFS security fix never sent to -stable?
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Kees Cook <keescook@google.com>, Dwight Engen <dwight.engen@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Ben Myers <bpm@sgi.com>, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 7:15 AM, Luis Henriques
<luis.henriques@canonical.com> wrote:
> On Thu, Dec 05, 2013 at 04:35:50PM -0800, Kees Cook wrote:
>> Hi,
>>
>> It looks like 8c567a7fab6e086a0284eee2db82348521e7120c ("xfs: add
>> capability check to free eofblocks ioctl") is a security fix that was
>> never sent to -stable? From what I can see, it was introduced in 3.8
>> by 8ca149de80478441352a8622ea15fae7de703ced ("xfs: add
>> XFS_IOC_FREE_EOFBLOCKS ioctl").
>>
>> I don't see this in the 3.8.y tree. Should it be added there and newer?
>
> Thanks Kees, I'm queuing it for the 3.11 kernel.

There's also this one:

http://thread.gmane.org/gmane.comp.file-systems.xfs.general/57654

It fixes CVE-2013-6382

josh
