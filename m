Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbaGRC7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 22:59:03 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:58158 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaGRC7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 22:59:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140718090325.32eb36bb@canb.auug.org.au>
References: <CAPDOMViJfR2qqNRkx_mKpQ0FWd76YN77ev3M=0boZFW6NvS3Pg@mail.gmail.com>
	<20140718090325.32eb36bb@canb.auug.org.au>
Date: Thu, 17 Jul 2014 22:58:59 -0400
Message-ID: <CAPDOMVjOVW3y9cc-6wnh0wtoX9F8AMCNZ4WDV5QJFn4riQ2WXg@mail.gmail.com>
Subject: Re: Build allyesconfig for PowerPc tested
From: Nick Krause <xerofoify@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 7:03 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Nick,
>
> On Thu, 17 Jul 2014 14:49:29 -0400 Nick Krause <xerofoify@gmail.com> wrote:
>>
>> For a while allyesconfig for powerpc seemed to fail building I ran the
>> test today to check if
>> it builds. It seems to build for me but with warnings. Furthermore
>> there seem to be a few
>> warnings that need clean up. I can either send another email to the
>> maintainers of the powerpc
>> architecture branch or you can with my logs as I am attaching them here,
>
> Powerpc allyesconfig will not build completely, this has been known for
> a long time.  Even your log shows it failing, so I do not understand
> what you are saying.  (BTW, that is not the normal way for the build to
> fail, it will always fail when trying to link vmlinux.  Maybe you are
> missing some tool to build the kernel signing keys?)
>
> You should report warnings/failures in subsystems to the appropriate
> subsyetem maintainer, just because you get these for a particular
> architecture does not mean that they are the responsibility of that
> architecture maintainer.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


That's fine I will send this to the maintainer of the powerpc architecture .
I would like to see this get mixed soon.
Cheers Nick
