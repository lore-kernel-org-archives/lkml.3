Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbbAXJDP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 04:03:15 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48867 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbbAXJDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 04:03:08 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20150123053056.GC29656@ZenIV.linux.org.uk>
References: <20150122045303.1347.98054.stgit@localhost>
	<20150122075429.GV29656@ZenIV.linux.org.uk>
	<4011794.crgx99Gu8a@sifl>
	<25860171.h6aocaXFeh@sifl>
	<20150122212902.GW29656@ZenIV.linux.org.uk>
	<20150122214000.GX29656@ZenIV.linux.org.uk>
	<20150123053056.GC29656@ZenIV.linux.org.uk>
Date: Sat, 24 Jan 2015 10:03:06 +0100
Message-ID: <CA+icZUWOkW-ujARrnT4T3wsZh0EbkHR+p2q2c1-zJYKtP46hfA@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Overhaul the audit filename handling
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Paul Moore <pmoore@redhat.com>, Guenter Roeck <linux@roeck-us.net>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-audit@redhat.com,
        rgb@redhat.com, sd@queasysnail.net,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 6:30 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Jan 22, 2015 at 09:40:01PM +0000, Al Viro wrote:
>> On Thu, Jan 22, 2015 at 09:29:03PM +0000, Al Viro wrote:
>> > On Thu, Jan 22, 2015 at 04:25:13PM -0500, Paul Moore wrote:
>> >
>> > > Your experimental branch looks good to me, thanks.
>> >
>> > Pushed into for-next; I'm probably going to move that stuff into a never-rebased
>> > branch, merged into for-next and safe to pull into your tree if you want to do
>> > something on top of that set.
>>
>> OK, vfs.git#getname is it; it's in never-to-be-rebased mode and it's merged
>> into vfs.git#for-next (as of right now; HEAD is 9ee4c4).  If you need to do
>> something on top of that stuff, pulling vfs.git#getname is safe.
>
> Unfortunately, that thing was -rc2-based, leading to conflict with mainline
> in kernel/auditsc.c.  My fault, I hadn't realized that "audit: create private
> file name copies when auditing inodes" in audit tree was, in fact, present in
> mainline.  vfs.git#getname2 is -rc3-based, same resulting kernel/auditsc.c as
> in #getname.  Please, use that.  vfs.git#for-next merges from that one now,
> so tomorrow -next should have no problems from vfs.git...
>

I have tested vfs.git#getname2 on top of Linux v3.19-rc5-184-gc4e00f1
(plus block-loopmq patchset) and it boots fine on Ubuntu/precise
amd64.

Just curious, where will this audit-filename-handling overhaul go through?
Through Paul's audit-next or Al's vfs-next tree?

AFAICS, a new linux-next will be available on Monday (2015-01-26).
I try to retest with this.

- Sedat -
