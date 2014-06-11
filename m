Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731AbaFKQ72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:59:28 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:50174 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaFKQ71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:59:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAASgrz2=NA96ZZe8GRfnZ_m2woLc=QaAizj6yVA8Jgbi-O3rfQ@mail.gmail.com>
References: <1399421543-7751-1-git-send-email-davidriley@chromium.org>
	<1400106617-17085-1-git-send-email-davidriley@chromium.org>
	<CAASgrz2=NA96ZZe8GRfnZ_m2woLc=QaAizj6yVA8Jgbi-O3rfQ@mail.gmail.com>
Date: Wed, 11 Jun 2014 09:59:26 -0700
Message-ID: <CALAqxLXuSXBXPyxoSeAPiCSfnHWoKev_ps32jSK_pntFo1_yrQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Add test to validate udelay
From: John Stultz <john.stultz@linaro.org>
To: David Riley <davidriley@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Riley <davidriley@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 4:41 PM, David Riley <davidriley@google.com> wrote:
> Hi,
>
> I was wondering if there were any comments to this patch or if it was
> picked up somewhere?

So I guess it got left in a bit of an ambiguous spot.  The basic point
of this test is to verify there is a sane counter time-based delay on
freq shifting systems. You've addressed my only false positive
concern, and so I'm not opposed to including it.

However, there was the following discussion of why this test was
wanted, and that was due to a system that didn't have a counter time
based delay (instead using the loop delay) which was running into
problems with cpufreq changes. That discussion wandered a bit, but the
consensus was "don't do that".

I sort of mixed the messages and associated that feedback with this
patch as well, so my apologies.

Just to be clear, it might be good to more clearly target this test as
a validation to ensure systems don't use those bad configs. So If you
want to resend with that extra context in the commit message, I'll go
ahead and queue it (looking at 3.17)

thanks
-john
