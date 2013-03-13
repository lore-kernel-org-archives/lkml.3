Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3CMJxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:53:06 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:39014 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3CMJxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:53:05 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAK2H+edwEjoRK0MWMBi0iXtAnGH8nvJgVRpvvEmo7FQ2VeMiiA@mail.gmail.com>
References: <CA+icZUUqSCZeb2JOFv-OSRXAQyD+crvGqg9E0FAUF=+ZAg5vFA@mail.gmail.com>
	<CAK2H+edwEjoRK0MWMBi0iXtAnGH8nvJgVRpvvEmo7FQ2VeMiiA@mail.gmail.com>
Date: Wed, 13 Mar 2013 10:53:01 +0100
Message-ID: <CA+icZUXgEZ3ihYQbEf3-FDvn5Mb2SiL8Tjb2_D9oAuhvSQ1gpQ@mail.gmail.com>
Subject: Re: Status of union-mount?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Mark Knecht <markknecht@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Erez Zadok <ezk@cs.sunysb.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 6:18 PM, Mark Knecht <markknecht@gmail.com> wrote:
> On Tue, Mar 12, 2013 at 9:55 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> Hi,
>>
>> what's the status of union-mount?
>> Where does the development happen - in [1]?
>>
>> Regards,
>> - Sedat -
>>
>> [1] http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=unionmount
>
> Sedat,
>    Did you look here for info?
>
> http://unionfs.filesystems.org/
>

[ CC Erez ]

Hi,

UnionFS is a different solution than union-mount.
Checking the official GIT repositories, the last commit is from February 2012.
Can't say if the development stopped.

Regards,
- Sedat -

[1] http://git.fsl.cs.sunysb.edu/?p=unionfs-latest.git;a=commitdiff;h=6a0a7bb2656c8790d355e2dfcdd13332da319b8f

> Cheers,
> Mark
