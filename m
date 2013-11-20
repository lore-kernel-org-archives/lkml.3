Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3KTBxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 20:53:38 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:47123 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3KTBxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 20:53:37 -0500
MIME-Version: 1.0
In-Reply-To: <CANK3SE36i0+NQdEtuO+FFebDKtrBBM=RjzB4WqSun2o1FK3xpA@mail.gmail.com>
References: <62a00a45d2fc38d1881f153f35ba282e85d78a3e.1384518190.git.gamerh2o@gmail.com>
	<CANK3SE36i0+NQdEtuO+FFebDKtrBBM=RjzB4WqSun2o1FK3xpA@mail.gmail.com>
Date: Wed, 20 Nov 2013 09:53:36 +0800
Message-ID: <CAAb+SYbnL7bNd6+yibrp+bYRKCM+kC_X+kg+KUsZtGj2S0JaaA@mail.gmail.com>
Subject: Re: [PATCH 1/4] staging: et131x: clean up code
From: ZHAO Gang <gamerh2o@gmail.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm a bit confused - these patches apply to the current head of
> staging-next, but not on top of your previous two patches. I assume that
> you're aiming to have these changes on top of your last two, so can you
> please re-spin them to apply cleanly to the head of (staging-next + your
> previous patches)?

Hi, please revert the previous two patches if you can. This four
patches include previous changes, just more descriptive.

I think previous patches' style may be not so good, and it had
received no response when I sent this patch set, so I just dropped
them and redid the work :-)

Thanks for your review.
