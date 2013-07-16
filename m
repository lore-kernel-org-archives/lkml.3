Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab3GPNOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:14:19 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:36778 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab3GPNOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:14:17 -0400
MIME-Version: 1.0
In-Reply-To: <1373960616.2148.34.camel@dabdike>
References: <1373916476.2748.69.camel@dabdike>
	<20130715214422.GA2478@kroah.com>
	<1373951852.2148.9.camel@dabdike>
	<20130716062058.GB19052@kroah.com>
	<1373960616.2148.34.camel@dabdike>
Date: Tue, 16 Jul 2013 09:14:16 -0400
Message-ID: <CA+5PVA4_sG9j2f=-caqOV1r7UFu3ydYjUExAdCMKw+rR-+F67Q@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Josh Boyer <jwboyer@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Greg KH <greg@kroah.com>, ksummit-2013-discuss@lists.linuxfoundation.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 3:43 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Mon, 2013-07-15 at 23:20 -0700, Greg KH wrote:
>> On Tue, Jul 16, 2013 at 09:17:32AM +0400, James Bottomley wrote:
>> > On Mon, 2013-07-15 at 14:44 -0700, Greg KH wrote:
>> > > On Mon, Jul 15, 2013 at 11:27:56PM +0400, James Bottomley wrote:
>> > > > Before the "3.10.1-stable review" thread degenerated into a disagreement
>> > > > about habits of politeness, there were some solid points being made
>> > > > which, I think, bear consideration and which may now be lost.
>> > > >
>> > > > The problem, as Ji???? Kosina put is succinctly is that the distributions
>> > > > are finding stable less useful because it contains to much stuff they'd
>> > > > classify as not stable material.
>>
>> And I'm going to be working on that.
>
> OK, I accept that.
>
>> But I need, from the distros, specific examples of what they object to.
>> So far all I've gotten is one security patch (that was needed), and one
>> patch for sysfs that I backported too far in the version numbers (my
>> fault.)
>>
>> Given the huge number of stable patches over the past few years, only
>> having 2 patches be an issue sounds like things are working well for
>> people here.
>>
>> If I don't get pushback, with specifics, from the distros, I will not
>> know what to change, so if people can provide me that, it will help out
>> a lot.
>
> I agree ... I think Jiří and his Red Hat equivalent need to pipe up and
> give us more examples of the problems they've been having.

I'm actually more concerned about the glut of patches showing up in
the .1 releases because people didn't bother to send fixes to Linus
for the .0 release.  I think it is a clear sign that the stable tree
is working fairly well when we don't bother to push out a rebase to a
new release until the .1 or .2 stable tree is out there.  It's a
warning sign for the actual .0 release though.

Now, that being said, there are cases where .1 can be broken too.
There have been a couple of changes that showed up during a merge
window that were sucked into -stable through the CC tag, and then
later found to be broken.  Those resulted in reverts or significant
fixes that then took a while to get reverted in -stable or required
different temporary fixes because the upstream fix was too invasive.
That's mainly a problem of them not getting enough testing before
hitting Linus' tree I suppose, but the CC: stable tag being on them
doesn't help.

Forgive me for not having immediate concrete examples here.  I'm
sitting in the middle of nowhere on a lake using tethering for
internet and hiding from my wife so she doesn't catch me doing "work".
 Crap, I think she's coming...

josh
