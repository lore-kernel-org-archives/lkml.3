Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab3ATVYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 16:24:31 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:50858 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab3ATVY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 16:24:29 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CA+icZUXpp=PF2dJ93RJtMaaWbqoAZ9Oiqt6QPXsE1AiR-D4gGg@mail.gmail.com>
References: <CA+icZUXpp=PF2dJ93RJtMaaWbqoAZ9Oiqt6QPXsE1AiR-D4gGg@mail.gmail.com>
Date: Sun, 20 Jan 2013 22:24:28 +0100
Message-ID: <CAKMK7uG7no98LGGEZ1nH=6V6HPgYZeZaJE8Jmo_np4DDZtwJ6Q@mail.gmail.com>
Subject: Re: [PULL] kms locking rework
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: sedat.dilek@gmail.com
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 10:15 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> Hi Daniel,
>
> I am testing your patchset (original postings at [1]).
> At a 1st look it seems to be OK.
> Any tests you want me to run?

Imo the fundamentals of the series are well-tested with the i-g-t
series, so running things on as many (non-i915) gpus as possible is
the most interesting thing. I just don't have that many radeon/nouveau
machines lying around for that ...

If you want to get really fancy, set up a zaphod dual-head config with
2 independent X servers to check whether concurrent pageflips don't
cause havoc. That needs something which pageflips, ofc.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
