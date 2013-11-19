Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab3KSNaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:30:19 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:50701 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab3KSNaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:30:16 -0500
MIME-Version: 1.0
In-Reply-To: <20131118135210.GB12931@kroah.com>
References: <20131115040944.GA28070@kroah.com> <CEAC7771.817BF%andreas.dilger@intel.com>
 <20131116195947.GB9308@kroah.com> <CA+a=Yy7LrEREU+9BbDy6cOpEFSdcNoYjsWnhBF1tv-OcHfKMpQ@mail.gmail.com>
 <20131118043942.GB3971@kroah.com> <CA+a=Yy7=Yq3-+fi9nVemoKk=FPaHiqot8d5KvJj1nDvA9+QU0A@mail.gmail.com>
 <20131118135210.GB12931@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Tue, 19 Nov 2013 21:29:55 +0800
Message-ID: <CA+a=Yy5sd45W-cuocyE7CPeDy879XHO80C9Wg8ut_0_u0j3Zzw@mail.gmail.com>
Subject: Re: [PATCH 04/40] staging/lustre/llite: Access to released file trigs
 a restore
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Dilger, Andreas" <andreas.dilger@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "faibish, sorin" <faibish_sorin@emc.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 9:52 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Nov 18, 2013 at 02:07:02PM +0800, Peng Tao wrote:
>> >> > So, why would I believe that you all are really going to start doing the
>> >> > major cleanup work on this code that is so obviously needed?  Why would
>> >> > I take new features that you are spending your time on instead?
>> >> >
>> >> My apologize. I was distracted by other projects for some time and I
>> >> am trying to make it up. I thought you agreed that I can first close
>> >> the patch gap between in-kernel client and external tree, and then add
>> >> cleanup patches, no?
>> >
>> > What exactly is "the gap"?  Are we talking 200 patches?  10?  100?  I
>> > have no idea what you are referring to, but realize I can't review 100
>> > patches at a single time easily.
>> >
>> Right now, I think it is about 150 patches. I will split them into
>> smaller chunks (10 patches or in each patchset) and send them
>> incrementally.
>
> Good.
>
>> > And what happens when I accep these "gap" patches?  Will development in
>> > this external tree suddenly stop?  It sure doesn't seem like this is
>> > happening as I thought it would have already since the code has been in
>> > the kernel for over 6 months now.
>> >
>> No, it won't stop. The biggest feature coming in this time is HSM. In
>> future, I think there will be less features and more bug fixes.
>> Porting patches from external tree isn't just to make the two tree in
>> sync. External tree contains many bug fix patches that in kernel
>> client wants as well. If we stop porting, as time goes by, the in tree
>> client will be less featured, and more buggy than external tree. When
>> we get it out of staging like that, it will be very hard to persuade
>> people to use it.
>
> So, who is going to take the time to do the cleanup and work involved in
> getting this into mergable state, if developers are off adding new
> features to your out-of-tree kernel code?
>
I am to work on it.

> I _really_ hate taking new features for staging drivers, as that shows
> that the developers are using staging as just a dumping ground to get
> stuff merged, without taking the time to get it cleaned up properly.
>
> If this continues, and no major work is done to clean things up within
> the next 6 months (i.e. the same thing as the past 6 months.) this code
> will be deleted from the tree.  You have been warned.
>
Got it.

Thanks,
Tao
