Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbaCEERc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:17:32 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:55509 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbaCEERa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:17:30 -0500
MIME-Version: 1.0
In-Reply-To: <20140304104447.GA4891@pd.tnic>
References: <20140228140043.GA12157@debian.local>
	<20140302205619.GA8676@rhlx01.hs-esslingen.de>
	<20140303080432.GA25489@localhost>
	<20140303192939.GD31265@pd.tnic>
	<20140304050122.GA3740@localhost>
	<5e866e2a-ea92-43f8-ae67-23f6052c91c8@email.android.com>
	<20140304060559.GA547@localhost>
	<20140304104447.GA4891@pd.tnic>
Date: Wed, 5 Mar 2014 11:17:30 +0700
Message-ID: <CAP-bSRZ9vfjF=6f1HJvj7ahtbm6mTABRAe0wqMrvzrzPsc_OHw@mail.gmail.com>
Subject: Re: Re: [PATCH] x86: set Pentium M as PAE capable
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andreas Mohr <andi@lisas.de>,
        Dennis Mungai <dmngaie@gmail.com>, x86@kernel.org,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        devzero@web.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 March 2014 17:44, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Mar 04, 2014 at 01:06:03PM +0700, Chris Bainbridge wrote:
>> On Mon, Mar 03, 2014 at 09:04:19PM -0800, H. Peter Anvin wrote:
>> > forcepae is descriptive.
>>
>> Back to forcepae.
>
> Ok, it looks ok to me after a quick look. Now you only have to ask
> Dave whether he's fine with you merging his patch into yours, write a
> nice commit message explaining why this patch is needed and give it a
> final test on your machine.

Dave - are you ok with the merge?

I take it I am expected to re-post the most recent patch plus
changelog entry as a new thread (and with a subject that better
reflects the new patch)?
