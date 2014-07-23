Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbaGWPf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:35:27 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:63511 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765AbaGWPfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:35:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140723103707.64071c00@gandalf.local.home>
References: <1406004789-9918-1-git-send-email-xerofoify@gmail.com>
	<874my98p6u.fsf@nemi.mork.no>
	<CA+8MBb+fnCNeQtyEqttxbkWx-4N+GUaKCUoCSdn5X9+bDDvTOg@mail.gmail.com>
	<CAPDOMVjaf+vne4vbUPo8EPs0XnQBbNm2ZOXns8fw5pkg9tRSww@mail.gmail.com>
	<CAAsK9AGtdJiz0xnmfqLBAqxmt=r+WANsmxwB_vQ3O5aKzMW1LQ@mail.gmail.com>
	<CAPDOMVhj72TFKbtw_93juX19WVdfUzh3KM9tCEjbTdUZvUfcUQ@mail.gmail.com>
	<20140722193350.GA486@home.goodmis.org>
	<CAPDOMVipLiXuYqndO_gnMYocDLVsHX9zcTdSMUV_EjJo72nx6w@mail.gmail.com>
	<20140723103707.64071c00@gandalf.local.home>
Date: Wed, 23 Jul 2014 11:35:21 -0400
Message-ID: <CAPDOMVh+zVQZQWjS1mTDmZo9frvk9t+kzN4_cOaoDgaNePF2AA@mail.gmail.com>
Subject: Re: [PATCH] edac: Remove fixmes in e7xxx_edac.c
From: Nick Krause <xerofoify@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Levente Kurusa <lkurusa@redhat.com>, Tony Luck <tony.luck@gmail.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:37 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 22 Jul 2014 16:56:06 -0400
> Nick Krause <xerofoify@gmail.com> wrote:
>
>> On Tue, Jul 22, 2014 at 3:33 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > On Tue, Jul 22, 2014 at 02:25:24PM -0400, Nick Krause wrote:
>> >>
>> >> I understand what your saying and I should have searched for Page shift.
>> >> In addition I am already got commits in the kernel for fix mes so I feel
>> >> that your comment on fix mes is incorrect.
>> >
>> > After seeing your other solutions to "fix mes" around the kernel, I now have to
>> > investigate the patches that were accepted, and see if they did not cause
>> > any new bugs. If any of them do, I will ask to have all your patches reverted.
>> >
>> > You are not helping. You are actually doing quite the opposite. Who do you work
>> > for? Microsoft or Apple?
>> >
>> > -- Steve
>> >
>>
>> I don't work for any companies. And here is one of them that has been accepted.
>> I am removing two fix mes in this file as after dicussing then it  seems
>> there is no reason to check against Null for usb_device as it can never
>> be NULL and this is check is therefore not needed.
>
> http://marc.info/?l=linux-m68k&m=140612440420712&w=2
>
> And your patches seem to be getting reverted. Wow, I think you broke a
> new record in having the percentage of patches added to the kernel and
> then reverted. Even before they made it to mainline.
>
> You may be the only developer that has all their commits reverted
> before they ever make it into the mainline tree!
>
> Congratulations! I think it is wise now for all maintainers to add your
> email to their /dev/null folder. It will help them from wasting any
> more of their precious time on you.
>
> -- Steve
Steve, I  have make a few mistakes. That doesn't give you the right to
put me under a waste of time yet.
Nick
