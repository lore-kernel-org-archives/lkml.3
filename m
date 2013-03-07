Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab3CGLU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:20:57 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37014 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab3CGLUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:20:54 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1303071130520.28677@pobox.suse.cz>
References: <20130306115052.2b1969acb7b7a0fa35975984@canb.auug.org.au>
	<51379849.6040903@infradead.org>
	<CAN+gG=H4_1nUhhsUe031Q1QrnVna+F7hmAepe6kbNm=8z_gOjw@mail.gmail.com>
	<alpine.LNX.2.00.1303071108150.28677@pobox.suse.cz>
	<CAN+gG=HhatpiPWUJ72Pr45odtcM6AJ5broNVrQ_=dF5AU6TEig@mail.gmail.com>
	<alpine.LNX.2.00.1303071130520.28677@pobox.suse.cz>
Date: Thu, 7 Mar 2013 12:20:52 +0100
Message-ID: <CAN+gG=GftPSHEbrsFkjQdCdGeRXQvDU-=c7bhBxK9n5YRQe2iQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Mar 6 (hid)
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 11:33 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 7 Mar 2013, Benjamin Tissoires wrote:
>
>> You should have at least one other patch for hid-mt:
>> https://patchwork.kernel.org/patch/2193641/
>
> Ah, right, that one is in my queue as well, sorry for not mentioning it in
> my previous post.

No problems :)

>
> That doesn't remove the direct call either though.

true

>
>> And I sent as a RFC the patch I was talking about:
>> https://patchwork.kernel.org/patch/2193801/
>> https://patchwork.kernel.org/patch/2193821/
>>
>> These two RFCs have been reviewed by David Herrmann, so maybe we can
>> include them in their current form as no one else complained about it
>> ( maybe you will :) ).
>
> For some reason these two vanished between the cracks of my mailbox.
> Thanks for pointing those out, I will process them today and either apply
> it, or fix it for -next by adding a config dependency.
>

ok, thanks for dealing with it.

Cheers,
Benjamin
