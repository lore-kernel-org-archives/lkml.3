Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbaFYWzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:55:36 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:63891 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918AbaFYWzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:55:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1406252107070.15939@pobox.suse.cz>
References: <20140625115541.GA1409@localhost> <1403711966-13003-1-git-send-email-janne.kanniainen@gmail.com>
 <20140625174109.GE1409@localhost> <alpine.LNX.2.00.1406252107070.15939@pobox.suse.cz>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 25 Jun 2014 15:55:10 -0700
Message-ID: <CAK5ve-JnqpogKaG1V=mfvKEHMPb8ma4Zeyz9rF4kT-W2Gj=p0A@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] HID: leds: Use attribute-groups in MSI GT683R driver
To: Jiri Kosina <jkosina@suse.cz>
Cc: Johan Hovold <johan@kernel.org>,
        Janne Kanniainen <janne.kanniainen@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 12:09 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 25 Jun 2014, Johan Hovold wrote:
>
>> Did you see the attribute-race series I posted? Not sure how best to
>> handle the dependency, as those patches should probably go in through
>> the LEDs tree, while the first patch in that series (adding the groups
>> field) is a dependency for this patch.
>>
>> Jiri, how would this best be solved?
>
> I think the best course of action here is to gather Acks from the
> respective maintainers, and take the whole lot trough a single tree
> (probably the leds tree in this case) to avoid unnecessary intra-tree
> dependencies in a rather straighforward situation like this.
>

I think the better place is HID/input tree, since this patch depends
on the initial one which is not in my tree.
I'm going to merge Johan's whole patchset and this patch probably
depends Johan's work too.

-Bryan
