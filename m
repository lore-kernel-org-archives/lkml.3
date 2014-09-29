Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbaI2VFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 17:05:06 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:60031 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaI2VFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 17:05:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAD3Xx4K5hg-sZb5Ek=q=cgPt59+Y8wgAs1iEWOFx2EMcz3EZAg@mail.gmail.com>
References: <1411455508-11958-1-git-send-email-valentinrothberg@gmail.com>
	<5421A4B4.1040604@infradead.org>
	<1411492210.30136.15.camel@nebuchadnezzar>
	<5421A9D5.8020503@infradead.org>
	<1411496822.31476.1.camel@nebuchadnezzar>
	<1412021904.6334.97.camel@x220>
	<CAD3Xx4K5hg-sZb5Ek=q=cgPt59+Y8wgAs1iEWOFx2EMcz3EZAg@mail.gmail.com>
Date: Mon, 29 Sep 2014 14:05:02 -0700
X-Google-Sender-Auth: 3ci9Vo38mL9ZE8kgvu5UzAkmYI8
Message-ID: <CAGXu5jJHmj+t+VLZ8Ww=C2_cYr69HwxNmDb8rySD7qt0_+3+gw@mail.gmail.com>
Subject: Re: [PATCH] lib: rename TEST_MODULE to TEST_LKM
From: Kees Cook <keescook@chromium.org>
To: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 1:25 PM, Valentin Rothberg
<valentinrothberg@gmail.com> wrote:
> It has been merged already, see [1]. Sorry, I did not check if you
> were in the CC to let you know.

If it helps, I tend to use scripts/get_maintainer.pl when sending
patches. It's a nice way to see who touched the same areas your patch
touches, as well as doing all the filename and patch matching from the
items listed in MAINTAINERS.

-Kees

-- 
Kees Cook
Chrome OS Security
