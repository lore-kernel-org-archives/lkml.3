Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab3LJNPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:15:36 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:36476 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab3LJNPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:15:33 -0500
MIME-Version: 1.0
In-Reply-To: <20131210075621.GA30135@kroah.com>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
	<20131209121534.GE4278@hercules>
	<CA+5PVA4ychvLEi1ZZ6rYy2=5-wZAbQ_a-aoy8=1w3+tr-pt3Fg@mail.gmail.com>
	<20131209235523.GW31386@dastard>
	<20131210075621.GA30135@kroah.com>
Date: Tue, 10 Dec 2013 08:15:32 -0500
X-Google-Sender-Auth: ImqXTsb3JZUZaS7FCmf48dptBe0
Message-ID: <CA+5PVA7L0u9cq0Zvnw3J7Yun3+TfMH3fPC3M8=mvxT3EGKX=fQ@mail.gmail.com>
Subject: Re: XFS security fix never sent to -stable?
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kees Cook <keescook@google.com>,
        Dwight Engen <dwight.engen@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 2:56 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Dec 10, 2013 at 10:55:23AM +1100, Dave Chinner wrote:
>> [cc xfs list, cc stable@vger.kernel.org]
>>
>> On Mon, Dec 09, 2013 at 08:17:09AM -0500, Josh Boyer wrote:
>> > On Mon, Dec 9, 2013 at 7:15 AM, Luis Henriques
>> > <luis.henriques@canonical.com> wrote:
>> > > On Thu, Dec 05, 2013 at 04:35:50PM -0800, Kees Cook wrote:
>> > >> Hi,
>> > >>
>> > >> It looks like 8c567a7fab6e086a0284eee2db82348521e7120c ("xfs: add
>> > >> capability check to free eofblocks ioctl") is a security fix that was
>> > >> never sent to -stable? From what I can see, it was introduced in 3.8
>> > >> by 8ca149de80478441352a8622ea15fae7de703ced ("xfs: add
>> > >> XFS_IOC_FREE_EOFBLOCKS ioctl").
>> > >>
>> > >> I don't see this in the 3.8.y tree. Should it be added there and newer?
>> > >
>> > > Thanks Kees, I'm queuing it for the 3.11 kernel.
>> >
>> > There's also this one:
>> >
>> > http://thread.gmane.org/gmane.comp.file-systems.xfs.general/57654
>> >
>> > It fixes CVE-2013-6382
>>
>> First I've heard about it there being a CVE for that bug. Since when
>> has it been considered best practice to publish CVEs without first
>> (or ever) directly contacting the relevant upstream developers?
>>
>> But, regardless of how broken I think the CVE process is, commit
>> 071c529 ("xfs: underflow bug in xfs_attrlist_by_handle()") should be
>> picked up by the stable kernels.
>
> I don't see that commit in Linus's tree, is it not there yet?

Not yet.  Ben said it's applied but I'm not sure where that is.

josh
