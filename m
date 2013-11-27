Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab3K0Atx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:49:53 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:48597 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3K0Atq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:49:46 -0500
MIME-Version: 1.0
In-Reply-To: <201311270018.14980.s.L-H@gmx.de>
References: <201311262303.26996.s.L-H@gmx.de>
	<CAKb7UvinEmz4YFoes2w5JJp-sJ_tsDeAWj-Aa5Yw56m2=j3xHw@mail.gmail.com>
	<201311270018.14980.s.L-H@gmx.de>
Date: Tue, 26 Nov 2013 19:49:45 -0500
X-Google-Sender-Auth: _zuXQBza7TLbSolw66wjQihrRR4
Message-ID: <CAKb7UviWkEPnfgi3biTw6OqiSDU7Nnp9FYARMYv_S2h2zLU2LA@mail.gmail.com>
Subject: Re: nouveau/ NV11: 3.12 freezes if X.org is started headless
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: David Airlie <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 7:18 PM, Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:
> Hi
>
> On Tuesday 26 November 2013, Ilia Mirkin wrote:
>> On Tue, Nov 26, 2013 at 6:03 PM, Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:
>> > v3.11 is fine, with and without monitor attached.
>> > v3.12 is fine as long as X.org isn't started (but may fail to reboot
>> >       cleanly). If a monitor is connected I don't observe any problems,
>> >       it freezes without a monitor connected.
>> > v3.13-rc1-95-gb975dc3 appears not to freeze without a monitor anymore
>> >       (I didn't confirm that it's fine with a monitor attached), but I
>> >       end up with the following Oops (this is before X.org is started).

One more idea -- try it with nouveau.runpm=0 -- I've had some odd
results with it on my older cards (but I don't remember hangs, but I
also didn't spend a lot of time on it, just plopped the option in and
moved on). This is a feature that got in in 3.12, and is really the
only major nouveau-affecting change in that kernel for your card
revision.

  -ilia
