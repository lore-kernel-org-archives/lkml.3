Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbbATMgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:36:03 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58378 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbbATMgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:36:00 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20150120115625.GB11013@rei>
References: <20150119122310.GA27065@rei>
	<CA+icZUV53AWik-bS4a3DwgExD26nhCWxJWb-kGN_nAOWsikuLA@mail.gmail.com>
	<CA+icZUVSnYv3-rh6sBr8vgDsc80Qnr3yK_OZ6AezVHPrDcKXbg@mail.gmail.com>
	<20150120115625.GB11013@rei>
Date: Tue, 20 Jan 2015 13:35:58 +0100
Message-ID: <CA+icZUW3=TkMvEzs3DXZYt0BC5JjUtXiCsVSt3ikHwxPyzu3=A@mail.gmail.com>
Subject: Re: [LTP] The Linux Test Project has been released for JANUARY 2015
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp-list@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
        libc-alpha@sourceware.org, lwn@lwn.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 12:56 PM, Cyril Hrubis <chrubis@suse.cz> wrote:
> Hi!
>> > I will check my "iniza" setup of Linux v3.19-rc5 the "(runltp-)lite" way.
>> >
>>
>> Attached are the runltp-lite result and my kernel-config.
>>
>> I see a lot of "unexpected" failures, can you comment on them?
>
> Most of the failures comes from EBUSY while trying to umount
> filesystems. Do you have gvfsd-trash running? That thing is known to
> probe newly mounted filesystems preventing them from being unmounted for
> a certain amount of time.
>

Yupp, that popped up.
How can I disable that gvfsd (here: Ubuntu/precise?
And can this issue be documented?

- Sedat -
