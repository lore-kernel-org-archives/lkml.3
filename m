Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3J2Vgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:36:45 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:56815 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3J2Vgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:36:44 -0400
MIME-Version: 1.0
In-Reply-To: <20131029134346.9e5873bae3630e9a69891773@linux-foundation.org>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
	<CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
	<1814253454.3449.1382689853825.JavaMail.mail@webmail07>
	<CA+55aFxhJUrqdvw1To=9KLdxhYAOVwZLLeJT5yMRY5BT1weuHA@mail.gmail.com>
	<20131025091555.GA30895@kipc2.localdomain>
	<20131029203050.GE9568@quack.suse.cz>
	<20131029134346.9e5873bae3630e9a69891773@linux-foundation.org>
Date: Tue, 29 Oct 2013 14:36:43 -0700
X-Google-Sender-Auth: v3G6IltcXgij3bCjsEK_1LQVhjo
Message-ID: <CA+55aFy7N9GPJ8K613Homyh_-6=vhMWYOBRs9U01y4Y2sqF+JQ@mail.gmail.com>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Karl Kiniger <karl.kiniger@med.ge.com>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 1:43 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 29 Oct 2013 21:30:50 +0100 Jan Kara <jack@suse.cz> wrote:
>
>> Andrew has queued up a patch series from Maxim Patlasov which removes this
>> caveat but currently we don't have a way admin can switch that from
>> userspace. But I'd like to have that tunable from userspace exactly for the
>> cases as you describe below.
>
> This?
>
>     mm/page-writeback.c: add strictlimit feature
>
> That's already in mainline, for 3.12.

Nothing currently actually *sets* the BDI_CAP_STRICTLIMIT flag, though.

So it's a potential fix, but it's certainly not a fix now.

               Linus
