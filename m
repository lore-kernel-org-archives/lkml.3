Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965045AbaDIUxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 16:53:15 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:39613 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965000AbaDIUwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 16:52:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140409202224.GA12953@kroah.com>
References: <CAB=NE6VvyBKzEg=ErZzQMktY8eLytQ21JCPrOQbxvZ9m-nqHkw@mail.gmail.com>
 <53451077.2030102@openwrt.org> <CAB=NE6UUN4vQd3SpsvO5tcgaYq3YXQeE0KtZGki7p7OnR=J4RA@mail.gmail.com>
 <20140409191225.GA10560@kroah.com> <CAB=NE6VqY8yXoYuE0o01vq86imY8EtqLdkPa4bGMvR3bTaj5KQ@mail.gmail.com>
 <20140409202224.GA12953@kroah.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 9 Apr 2014 13:52:29 -0700
X-Google-Sender-Auth: KiTU1NrXtWcY6CX6smd1HfbaavI
Message-ID: <CAB=NE6XY5++p7hJQpQdwrFNUcGbUsKpC+oJiZQciXNduo+8j8A@mail.gmail.com>
Subject: Re: Bumping required kernels to 3.0 for Linux backports ?
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felix Fietkau <nbd@openwrt.org>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 1:22 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Apr 09, 2014 at 01:01:23PM -0700, Luis R. Rodriguez wrote:
>> On Wed, Apr 9, 2014 at 12:12 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Wed, Apr 09, 2014 at 11:28:55AM -0700, Luis R. Rodriguez wrote:
>> >> On Wed, Apr 9, 2014 at 2:18 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> >> > The oldest kernel in OpenWrt that we're still supporting with updates of
>> >> > the backports tree is 3.3, so raising the minimum requirement to 3.0 is
>> >> > completely fine with me.
>> >>
>> >> OK note that 3.3 is not listed on kernel.org as supported. I'm fine in
>> >> carrying the stuff for those for now but ultimately it'd also be nice
>> >> if we didn't even have to test the kernels in between which are not
>> >> listed. This does however raise the question of how often a kernel in
>> >> between a list of supported kernels gets picked up to be supported
>> >> eventually. Greg, Jiri, do you happen to know what the likelyhood of
>> >> that can be?
>> >
>> > I don't know of anything ever getting picked up after I have said it
>> > would not be supported anymore.
>>
>> Great! How soon after a release do you mention whether or not it will
>> be supported? Like say, 3.14, which was just released.
>
> I only mention it around the time that it would normally go end-of-life.
>
> For example, if 3.13 were to be a release that was going to be "long
> term", I would only say something around the normal time I would be no
> longer supporting it.  Like in 2-3 weeks from now.
>
> So for 3.14, I'll not say anything about that until 3.16-rc1 is out,
> give or take a week or two.
>
>> Also, as of late are you aware any distribution picking an unsupported
>> kernel for their next choice of kernel?
>
> Sure, lots do, as they don't line up with my release cycles (I only pick
> 1 long term kernel to maintain each year).  Look at the Ubuntu releases
> for examples of that.  Also openSUSE and Fedora (although Fedora does
> rev their kernel pretty regularly) don't usually line up.  The
> "enterprise" distros are different, but even then, they don't always
> line up either (which is why Jiri is maintaining 3.12...)
>
> Hope this helps,

It does! Unless I don't hear any complaints then given that some
distributions might choose a kernel in between and given also your
great documented story behind the gains on trying to steer folks
together on the 'ol 2.6.32 [0] and this now being faded, I'll be
bumping backports to only support >= 3.0 soon, but we'll include all
the series from 3.0 up to the latest. That should shrink compile /
test time / support time on backports to 1/2.

[0] http://www.kroah.com/log/linux/2.6.32-stable.html

  Luis
