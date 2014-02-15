Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaBOSl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 13:41:29 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:57173 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbaBOSl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 13:41:27 -0500
MIME-Version: 1.0
In-Reply-To: <20140215174424.GB32005@two.firstfloor.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
	<20140215133814.GA287@x4>
	<20140215174424.GB32005@two.firstfloor.org>
Date: Sat, 15 Feb 2014 10:41:27 -0800
Message-ID: <CAMe9rOrYY9eB0Je74iC0Yw5YwTaUPOqQ2fpr1RVPFTgyZaD0cA@mail.gmail.com>
Subject: Re: Updated Link-Time-Optimization patchkit
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 9:44 AM, Andi Kleen <andi@firstfloor.org> wrote:
> On Sat, Feb 15, 2014 at 02:38:14PM +0100, Markus Trippelsdorf wrote:
>> On 2014.02.14 at 22:21 +0100, Andi Kleen wrote:
>> > This is the updated LTO patchkit for 3.14-rc2.  LTO allows
>> > the compiler to do global optimization over the whole kernel.
>>
>> It is mildly annoying that one couldn't use vanilla binutils. Have you
>> already opened bugs on sourceware.org/bugzilla/ to get this fixed for
>> gold and ld.bfd?
>
> The problem is supporting "pass through" of both pure (.S) assembler code and
> LTO through ld -r, because the kernel makefiles use ld -r heavily.
> Standard binutils would throw all the assembler away when in plugin LTO
> mode.
>
> HJ did the work (and fixed a couple other bugs that blocked kernel LTO),
> but the mainline binutils people rejected the patches. You can judge
> for yourself if their reasons make sense:
>
> https://sourceware.org/ml/binutils/2012-05/msg00057.html
>
> Noone has done the work for gold so far.
>
> There was some effort from the Fedora binutils maintainers to add the
> necessary patches to their version, but at least what is in FC20 doesn't
> seem to be enough.

There are some additional LTO bug fixes in my Linux
binutils.

-- 
H.J.
