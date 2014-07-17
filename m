Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbaGQBQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 21:16:20 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:52196 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaGQBQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 21:16:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140717105144.2cb29989@canb.auug.org.au>
References: <20140716184550.18b6da3f@canb.auug.org.au>
	<CAPDOMViywcY=cYFT9EM3N3wESXQUX7uWa3jLLLKpv=QGF-Dtmw@mail.gmail.com>
	<20140717105144.2cb29989@canb.auug.org.au>
Date: Wed, 16 Jul 2014 21:16:16 -0400
Message-ID: <CAPDOMVh5_JXKwPQ9EwtXHLYnqNRhEMedF5F5K7H+PEqMuCZa8Q@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 16
From: Nick Krause <xerofoify@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> On Wed, 16 Jul 2014 20:45:25 -0400 Nick Krause <xerofoify@gmail.com> wrote:
>>
>> On Wed, Jul 16, 2014 at 4:45 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> >
>> > Status of my local build tests will be at
>> > http://kisskb.ellerman.id.au/linux-next .
>
>> I am trying to get the maintainers to clean up still failing builds.
>> When you get time I wondering
>> if you can send me a list  of still failing builds and warnings of
>> interest in the kernel that is'
>> up to date for me to help clean up these outstanding issues with the
>> maintainers support as needed.
>
> See above ...
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

There seems to be a few that are still succeeding for me that aren't for.
Would you mind testing some of them again to see if they are succeeding
with a gcc compiler that is newer then version 4.7.
Cheers Nick
