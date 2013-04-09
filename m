Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935900Ab3DIOcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:32:17 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:50019 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761650Ab3DIOcP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:32:15 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130410002311.8a0b0503bcbda151b9de9469@canb.auug.org.au>
References: <CA+icZUX-RMW=pHzhOumB2_R99BRAf2qGC4n5bzyLqU6pOCMDFw@mail.gmail.com>
	<20130409235941.11eef57a42cb97efec72f037@canb.auug.org.au>
	<CA+icZUVk-iLtodZi_46qmk410Ei+tW6RR5kV2fx0N8v6neKTPQ@mail.gmail.com>
	<20130410002311.8a0b0503bcbda151b9de9469@canb.auug.org.au>
Date: Tue, 9 Apr 2013 16:32:13 +0200
Message-ID: <CA+icZUUboWkL8vHvN6+xk=9kz8SXexxgMN-g+xuPB24T1wTSRw@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 9
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 4:23 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Sedat,
>
> On Tue, 9 Apr 2013 16:11:50 +0200 Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>
>> [ CC Al Viro ]
>
> You forgot to do that ...
>
>> Is there a "magic" git-command to revert all commits coming from your
>> latest vfs-merge (commit c1c04d3667608a630ae0821995b465a523e83fb1)?
>>
>> 2013-04-09 11:36 Stephen Rothwell   │ M─┐ │ │ │ │ │ │         │ 20130405/vfs
>
> You would normally do "git revert -m 1 c1c04d366760". However, that does
> not revert cleanly in today's linux-next (due to more patches modifying
> the files involved).
>

Just wanted to improve my git Know-How.

>> After reverting all these commits I would like to pull-in latest
>> vfs.git#for-next.
>
> It would probably be easier to wait for tomorrow's linux-next.  Or just
> test Al's tree in its own.

Doug reported problems on his way "reverting the current vfs stuff"
and Al's new tree was reported as OK.
A lot of merge-conflicts... that's what I see when trying to pull in
Al's tree in today's Linux-Next.
So, I better wait for tommorrow.

Anyway, a warning in your CHANGELOG is very much appreciated on such
KNOWN ISSUES.

Regards,
- Sedat -

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
