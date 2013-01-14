Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab3ANPfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 10:35:03 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:37789 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635Ab3ANPe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 10:34:59 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130114151220.GA20610@kroah.com>
References: <1357831934-31610-1-git-send-email-tomas.winkler@intel.com>
	<CA+icZUXa-cgNPTYAKjXDSkoqNhto7jz89yUMJAvYxa-jGtMbjg@mail.gmail.com>
	<20130114143238.GC20384@kroah.com>
	<CA+icZUXLFp_oZnVPcVDwuy_dvbywKgqHKknzg6qyF3o=mw-p+A@mail.gmail.com>
	<20130114151220.GA20610@kroah.com>
Date: Mon, 14 Jan 2013 16:34:58 +0100
Message-ID: <CA+icZUWUwn=SP-rnc=-K=J36vcUdOWURr2Kd_XV=fzCh+OMLJA@mail.gmail.com>
Subject: Re: [char-misc-next V2] mei: drop the warning when cl is not
 initialized during unlinking
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Tomas Winkler <tomas.winkler@intel.com>, arnd@arndb.de,
        alan@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 4:12 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Jan 14, 2013 at 03:55:44PM +0100, Sedat Dilek wrote:
>> On Mon, Jan 14, 2013 at 3:32 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Mon, Jan 14, 2013 at 03:14:50PM +0100, Sedat Dilek wrote:
>> >> On Thu, Jan 10, 2013 at 4:32 PM, Tomas Winkler <tomas.winkler@intel.com> wrote:
>> >>
>> >> Can you please apply this patch to char-misc-next?
>> >> I am hitting it again while doing other regression testing!
>> >
>> > Please be patient, it will get there soon.
>> >
>>
>> The same answer I got for the report/testing of [1], it is still not
>> in mainline.
>> Yes, I have seen your pull-request for char-misc-linus of today, but
>> why does this takes weeks to apply?
>
> "Weeks"?  You do realize this was sent to me over a holliday break, one
> in which I was on vacation?  I only returned a week ago, to over 1500
> patches to sift through and process.
>
> And, I did that within 4 days, and sent the needed fix off to Linus
> within 7 days of returning.
>
> If you think you can do better than that, wonderful, I would love for
> you to start out reviewing code and helping with handling stuff like
> that.  Please do so before complaining about anything.
>

The MAINTAINERS file lists a co-maintainer. Not sure what his job is.
In every company when people are on holidays, the work continues.

Speaking in general... regression fixes (freezing my machine on reboot
is one!) should be treat differently - faster!

I am testing GIT tree's before they enter mainline or Linux-Next.
And I am doing this in my free-time - I am not paid for it.
In a scrum talk the speaker called that (time) "units" (of work
especially in OSS projects)... "lost of free-time".
Maybe, I should look for a different hobby and wait til -rc4 is
released to be on the safe side of life.

In another email I was reflecting on a "arbritration board".
Good Mr. Torvalds said in an interview "I don't read code anymore"...
but what was with these fs/blkdev changes late in 3.7 cycle :-)?
There seems to be no rules except yours.
Right, you have the reponsibilty.

The last week I played with Linux Test Project and I still do NOT know
how to (really) test my kernels!
In each kernel-release (even rc) we read "please test" - but how?
Noone tells you this.
( A different story... )

Just some thoughts... for free.

- Sedat -

> greg k-h
