Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab3GWCLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:11:47 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:45992 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3GWCLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:11:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAELBVzCUrJXWB1dO2mOwoX97x+RO2AeCNEazXzG4DrHXSk9JmQ@mail.gmail.com>
References: <CAELBVzCK3Dm-HtAn3iy0Nz-MeOJVvRO20KqE0WojWF1nFv_-1Q@mail.gmail.com>
	<CAELBVzCUrJXWB1dO2mOwoX97x+RO2AeCNEazXzG4DrHXSk9JmQ@mail.gmail.com>
Date: Mon, 22 Jul 2013 19:11:44 -0700
X-Google-Sender-Auth: b8NCOyw9DZBUGvBIwYbULdRyJNI
Message-ID: <CA+55aFwQ02N=Q8ArztM-XhdC-cSj=GE-EvwvkarkpZfDUt+Rsg@mail.gmail.com>
Subject: Re: [Panic - Bisected] f1a18a10566081abfce1649c2f3884b28fff7372 cases
 panic on boot
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 July 2013 21:45, Kevin Winchester <kjwinchester@gmail.com> wrote:
> I have found that the new CPU Package temperature thermal driver introduced
> in this merge window causes my HP laptop to panic on boot.

I just merged Zhang's pull request that should contain a fix for this,
but was planning on the allmoconfig build finishing before pushing it
out. Give me a few minutes..

               Linus
