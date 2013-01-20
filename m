Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab3ATVnG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 16:43:06 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:63206 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3ATVnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 16:43:04 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAKMK7uG7no98LGGEZ1nH=6V6HPgYZeZaJE8Jmo_np4DDZtwJ6Q@mail.gmail.com>
References: <CA+icZUXpp=PF2dJ93RJtMaaWbqoAZ9Oiqt6QPXsE1AiR-D4gGg@mail.gmail.com>
	<CAKMK7uG7no98LGGEZ1nH=6V6HPgYZeZaJE8Jmo_np4DDZtwJ6Q@mail.gmail.com>
Date: Sun, 20 Jan 2013 22:43:02 +0100
Message-ID: <CA+icZUUsqejwefNPpApMyLCf5u5fd3pKUrGGQDCQGOghMah_Vg@mail.gmail.com>
Subject: Re: [PULL] kms locking rework
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 10:24 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Sun, Jan 20, 2013 at 10:15 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> Hi Daniel,
>>
>> I am testing your patchset (original postings at [1]).
>> At a 1st look it seems to be OK.
>> Any tests you want me to run?
>
> Imo the fundamentals of the series are well-tested with the i-g-t
> series, so running things on as many (non-i915) gpus as possible is
> the most interesting thing. I just don't have that many radeon/nouveau
> machines lying around for that ...
>

I am here on SNB, so.

> If you want to get really fancy, set up a zaphod dual-head config with
> 2 independent X servers to check whether concurrent pageflips don't
> cause havoc. That needs something which pageflips, ofc.

Sounds like a lot of work...
Any docs/wiki around to manage such a setup?

- Sedat -

> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
