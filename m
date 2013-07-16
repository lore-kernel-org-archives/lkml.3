Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435Ab3GPCVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:21:45 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:50621 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3GPCVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:21:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130716000755.GC26261@kroah.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
 <1373908589.2062.18.camel@joe-AO722> <20130715184030.GA17220@kroah.com>
 <20130715121357.42ef2826750909c1fc57788a@linux-foundation.org> <20130716000755.GC26261@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Tue, 16 Jul 2013 10:21:23 +0800
Message-ID: <CA+a=Yy6cC9rYcmAka2652UhJFse9eVfOtfg96SiObBiwsw+zQQ@mail.gmail.com>
Subject: Re: [PATCH-v3 00/17] staging/lustre: fix various build issues
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 8:07 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Jul 15, 2013 at 12:13:57PM -0700, Andrew Morton wrote:
>> On Mon, 15 Jul 2013 11:40:30 -0700 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>
>> > On Mon, Jul 15, 2013 at 10:16:29AM -0700, Joe Perches wrote:
>> > > On Mon, 2013-07-15 at 22:27 +0800, Peng Tao wrote:
>> > > > Hi Greg,
>> > > >
>> > > > Now that 3.11-rc1 is out, please consider queuing following patches to
>> > > > fix various Lustre client build issues. I've verified that we can now
>> > > > pass build on sparc/mips/s390/powerpc/x86, both 32bits and 64bits.
>> > >
>> > > These patches apply to linus' current, but not to -next
>> > > where other lustre patches have already been applied.
>> >
>> > What trees are those in?  I have nothing in my staging-next branch right
>> > now, so they didn't come from there, which is where I will be applying
>> > this to.
>>
>> See the five patches I sent you on July 8 ;)
>>
>> I'll resend.
>
> I got them, I couldn't apply them until after -rc1 is out, so I'll queue
> them up later this week.
>
Hi Greg and Andrew,

One issue with the five patches is that the shrinker API change is not
in Linus' tree. So if Greg merges them in staging tree, Lustre cannot
build there. Is it OK to break in staging tree and just to make sure
-next can build?

Thanks,
Tao
