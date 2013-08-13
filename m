Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab3HMXzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:55:24 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:54638 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab3HMXzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:55:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130813231020.GA22667@asylum.americas.sgi.com>
References: <1375465467-40488-1-git-send-email-nzimmer@sgi.com>
	<1376344480-156708-1-git-send-email-nzimmer@sgi.com>
	<CA+55aFwTQLexJkf67P0b7Z7cw8fePjdDSdA4SOkM+Jf+kBPYEA@mail.gmail.com>
	<520A6DFC.1070201@sgi.com>
	<CA+55aFwRHdQ_f6ryUU1yWkW1Qz8cG958jLZuyhd_YdOq4-rfRA@mail.gmail.com>
	<20130813231020.GA22667@asylum.americas.sgi.com>
Date: Tue, 13 Aug 2013 16:55:21 -0700
X-Google-Sender-Auth: WPv1Wvv-5BTSGu9X12pvtElDycU
Message-ID: <CA+55aFyeEK6FfNC-7SjGdYVrjiES0V7JNUG==P5p6iu+UNiAfA@mail.gmail.com>
Subject: Re: [RFC v3 0/5] Transparent on-demand struct page initialization
 embedded in the buddy allocator
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: Mike Travis <travis@sgi.com>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Robin Holt <holt@sgi.com>,
        Rob Landley <rob@landley.net>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 4:10 PM, Nathan Zimmer <nzimmer@sgi.com> wrote:
>
> The only mm structure we are adding to is a new flag in page->flags.
> That didn't seem too much.

I don't agree.

I see only downsides, and no upsides. Doing the same thing *without*
the downsides seems straightforward, so I simply see no reason for any
extra flags or tests at runtime.

               Linus
