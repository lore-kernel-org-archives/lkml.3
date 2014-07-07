Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaGGUKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:10:07 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:34852 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaGGUKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:10:06 -0400
MIME-Version: 1.0
In-Reply-To: <1404757366.2014.13.camel@x220>
References: <CAPDOMVieG951+0chzvjmKTdpZf-fEB5mjUL9YK-rgqF3+O537w@mail.gmail.com>
	<20140707134637.GA31174@thunk.org>
	<CAPDOMVjEmVJJEd_LVpCkXC8qR7APTKeHNJQSQ5SFNuWj9BQuLA@mail.gmail.com>
	<1404757366.2014.13.camel@x220>
Date: Mon, 7 Jul 2014 16:10:04 -0400
Message-ID: <CAPDOMVh=WghTAm-O8HvbEXb4Qrp03bHJuw_qp9gp2Jmiov38mg@mail.gmail.com>
Subject: Re: Arm Compiler - Part 1 of Compiling Tests
From: Nick Krause <xerofoify@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do known what they mean. It's good work for a long time
that isn't getting worked on therefore it seems good for
me to work on.
Cheers Nick

On Mon, Jul 7, 2014 at 2:22 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Mon, 2014-07-07 at 13:35 -0400, Nick Krause wrote:
>> On the other hand there seems to be too many FIXMEs in the main
>> kernel for one person to fix.
>
> A quick grep for FIXMEs (also including the "XXX" pattern, which
> basically means the same thing) triggers over 7000 hits. Even with a
> (rather optimistic) one hour per FIXME that's over three years of work
> (assuming a sane working hours/year metric).
>
> Moreover, you appear to misunderstand the meaning of these FIXMEs. It's
> not a marker for something trivial that somehow never got done. It might
> actually mean all kind of things. In many cases it points at a hard, or
> time consuming, etc., problem that no one has yet found a way, or the
> time, to fix properly.
>
> I would not advise someone new to the kernel to grep for FIXMEs to see
> if they could contribute something. There are many things those people
> could do, but those FIXMEs seem an awkward place to start.
>
>
> Paul Bolle
>
