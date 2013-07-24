Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab3GXA4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 20:56:20 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:38771 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200Ab3GXA4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 20:56:18 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwQ02N=Q8ArztM-XhdC-cSj=GE-EvwvkarkpZfDUt+Rsg@mail.gmail.com>
References: <CAELBVzCK3Dm-HtAn3iy0Nz-MeOJVvRO20KqE0WojWF1nFv_-1Q@mail.gmail.com>
	<CAELBVzCUrJXWB1dO2mOwoX97x+RO2AeCNEazXzG4DrHXSk9JmQ@mail.gmail.com>
	<CA+55aFwQ02N=Q8ArztM-XhdC-cSj=GE-EvwvkarkpZfDUt+Rsg@mail.gmail.com>
Date: Tue, 23 Jul 2013 21:56:17 -0300
Message-ID: <CAELBVzDcwmEsDDgSrAk_AGFrwyqXh9Qh6d6NB21_YsQDrTBz2w@mail.gmail.com>
Subject: Re: [Panic - Bisected] f1a18a10566081abfce1649c2f3884b28fff7372 cases
 panic on boot
From: Kevin Winchester <kjwinchester@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 July 2013 23:11, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On 22 July 2013 21:45, Kevin Winchester <kjwinchester@gmail.com> wrote:
>> I have found that the new CPU Package temperature thermal driver introduced
>> in this merge window causes my HP laptop to panic on boot.
>
> I just merged Zhang's pull request that should contain a fix for this,
> but was planning on the allmoconfig build finishing before pushing it
> out. Give me a few minutes..
>

Yes, I have tested with your latest tree, and it works even with the
driver enabled.

Thanks!

Kevin
