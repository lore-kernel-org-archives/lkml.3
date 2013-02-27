Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab3B0L5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 06:57:10 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:57516 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414Ab3B0L5J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 06:57:09 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAFLxGvycGCyeg7AhJ=3J0ztZfgYLmyKZSrzNUd5ymAb-tSd4qg@mail.gmail.com>
References: <EB937501617BFC44BE90EDA24CA6A13A0117EB@SGSIMBX003.nsn-intra.net>
	<512C56AF.1030801@oracle.com>
	<CAFLxGvyQmPz_iK26NavuRdBWAFiWzmt8BMfL8f6rg_Qm4LF7WQ@mail.gmail.com>
	<CAFLxGvycGCyeg7AhJ=3J0ztZfgYLmyKZSrzNUd5ymAb-tSd4qg@mail.gmail.com>
Date: Wed, 27 Feb 2013 12:57:07 +0100
Message-ID: <CA+icZUXbcvDPRNk9mQqwJteDm6OLPekBf3-Y-2OaTu0tr_JNUw@mail.gmail.com>
Subject: Re: [Ocfs2-users] Kernel panic due to ocfs2
From: Sedat Dilek <sedat.dilek@gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Srinivas Eeda <srinivas.eeda@oracle.com>,
        "Ramappa, Ravi (NSN - IN/Bangalore)" <ravi.ramappa@nsn.com>,
        "ocfs2-users@oss.oracle.com" <ocfs2-users@oss.oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, david@sigma-star.at
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 12:52 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Tue, Feb 26, 2013 at 8:54 AM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Tue, Feb 26, 2013 at 7:31 AM, Srinivas Eeda <srinivas.eeda@oracle.com> wrote:
>>> This is due to a race in lock mastery/purge. I have recently fixed this
>>> problem but haven't yet submitted the patch to mainline. Please file a
>>> Service request with Oracle to get a one-off fix.
>>
>> Please submit the patch immediately.
>> Why does one need a f§&"!#$ SR from Oracle to have this fixed?
>
> So, where can I find this patch?
> Can you please share it with us insignificant and rubbishy community folks?
>
> https://oss.oracle.com/projects/ocfs2/source.html points to
> http://git.kernel.org/?p=linux/kernel/git/jlbec/ocfs2.git;a=summary
> This tree seems horrible outdated...
>

Looks like Al took some ocfs2 patches directly to his vfs GIT tree(s)
and sent to mainline.

- Sedat -

http://git.kernel.org/?p=linux/kernel/git/viro/vfs.git;a=shortlog;h=refs/heads/for-linus
http://git.kernel.org/?p=linux/kernel/git/viro/vfs.git;a=shortlog;h=refs/heads/for-next

> --
> Thanks,
> //richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
