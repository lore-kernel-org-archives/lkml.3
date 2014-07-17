Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaGQDje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 23:39:34 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64820 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaGQDjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 23:39:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140717131457.15f3fb4d@canb.auug.org.au>
References: <20140716184550.18b6da3f@canb.auug.org.au>
	<CAPDOMViywcY=cYFT9EM3N3wESXQUX7uWa3jLLLKpv=QGF-Dtmw@mail.gmail.com>
	<20140717105144.2cb29989@canb.auug.org.au>
	<CAPDOMVh5_JXKwPQ9EwtXHLYnqNRhEMedF5F5K7H+PEqMuCZa8Q@mail.gmail.com>
	<20140717114718.3895d851@canb.auug.org.au>
	<CAPDOMVipLjtRCyZUYCEYLsaKWUaEwM1KbRSS9COUtdHj0rodWw@mail.gmail.com>
	<20140717131457.15f3fb4d@canb.auug.org.au>
Date: Wed, 16 Jul 2014 23:39:30 -0400
Message-ID: <CAPDOMVjsmEVjyAaOgyLA3ybe+tCXwjrdJk3w=abEV1rNQ5zURg@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 16
From: Nick Krause <xerofoify@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 11:14 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Nick,
>
> On Wed, 16 Jul 2014 22:01:35 -0400 Nick Krause <xerofoify@gmail.com> wrote:
>>
>> Absolutely , I am using the latest kernel rc from git. I am using gcc
>> 4.8.3 and binutils 2.83.91.
>
> Then that has nothing to do with me ... I am the linux-next
> maintainer.  I just happen to use the same build test system as is also
> used to test Linus' tree (kisskb).  I hope you are looking at the right
> result pages for what you are testing.  The URL I gave you was for the
> linux-next builds, not Linus' tree.
>
>> In addition I am using  the default configurations as you are in less
>> I am doing it differently.
>> By the way xtensa-defconfig seems to fail because of binutils as I
>> discussed this with
>> the maintainers and they seemed to have tested it with a newer upstream binutils
>> then I am using and it succeeded it the linking failures I am seeing with it.
>
> Maybe we need per architecture minimum tools versions (instead of
> current global one).
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


That seems like a good idea. I am also curious if when there is a
build failure in
the mainline kernel if we can mail the logs to the maintainers of that
arch as if
we do it seems to get resolved much faster, usually in a day or two,
Cheers Nick
