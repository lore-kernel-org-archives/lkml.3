Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbaGNODR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:03:17 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:51970 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147AbaGNODF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:03:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140714125836.GA6966@kroah.com>
References: <1405278681-3348-1-git-send-email-peter.senna@gmail.com>
	<20140713193647.GA31010@kroah.com>
	<20140714085932.GA2958@hp-peter.rsr.lip6.fr>
	<20140714125836.GA6966@kroah.com>
Date: Mon, 14 Jul 2014 16:03:03 +0200
Message-ID: <CA+MoWDr2Th5ykjTQqjySJ3UYhJLLFoRCbaOGYt2_edrUORgazw@mail.gmail.com>
Subject: Re: [PATCH V2 1/4] staging: vt6556: Cleanup coding style issues
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Malcolm Priestley <tvboxspy@gmail.com>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Forest Bond <forest@alittletooquiet.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 2:58 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Jul 14, 2014 at 10:59:32AM +0200, Peter Senna Tschudin wrote:
>> On Sun, Jul 13, 2014 at 12:36:47PM -0700, Greg KH wrote:
>> > On Sun, Jul 13, 2014 at 09:11:18PM +0200, Peter Senna Tschudin wrote:
>> > > This patch cleanup coding style issues reported by checkpatch.
>> > >
>> > > Tested by compilation only.
>> > >
>> > > Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>> > > ---
>> > > Cahnges from V1:
>> > >  - Sent all patches in a series
>> >
>> > Why did you forget the other thing that I asked you to change?
>> >
>> > I can't take these as-is, sorry, please go back and re-read what I
>> > wrote...
>>
>> Actually I was trying to do what you asked me on this E-mail:
>>
>> -- // --
>> You just sent me 4 patches, all with the same subject (but at least 2 of
>> them had the order in which to apply them in, which is nice.)
>>
>> Please redo these such that they have a unique subject, and I can tell
>> which order to apply them in, as I really have no idea about the second
>> two.
>> -- // --
>>
>> I'm sending V3 as a single patch.
>
> That's going to get rejected as well :(
>
> You did put them in a nice order, but you had the same subject text for
> each patch, which I told you not to do, right?
>
> {sigh}
The noise was caused by my poor English language skills. When you wrote:

"Please redo these such that they have a unique subject, and I can tell
which order to apply them in, as I really have no idea about the second
two."

I understood:
 1 - redo these patches
 2 - such as they have a unique subject
 3 - in a way Greg can tell in which order to apply them

I just understood what you wanted today. Sorry for that.

But, there is a plain text attachment on my previous E-mail with the
V3 of the patch set. The V3 is a single patch instead of 4 patches, is
that ok? Should I resend in a new thread?


>
> greg k-h



-- 
Peter
