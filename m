Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab3IPDSy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 23:18:54 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:37182 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab3IPDSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 23:18:53 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzJtybx3B=zcv1atCD-wUMc1YLdXndjX_d_ZxTDUpmOrQ@mail.gmail.com>
References: <1379049145-16017-1-git-send-email-realmz6@kernel.org>
	<CA+55aFzJtybx3B=zcv1atCD-wUMc1YLdXndjX_d_ZxTDUpmOrQ@mail.gmail.com>
Date: Mon, 16 Sep 2013 11:18:52 +0800
Message-ID: <CAMk6uBkEWjmJyC6gPTC7B0E+0RehCwoDdcefsrVvCHFjmtC5PQ@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [GIT PULL] Blackfin updates for 3.12
From: Steven Miao <realmz6@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Miao <realmz6@kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Sep 13, 2013 at 10:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Sep 12, 2013 at 10:12 PM, Steven Miao <realmz6@kernel.org> wrote:
>>  arch/blackfin/mach-bf609/Kconfig                   | 1655 ++++++++++++++++++++
>
> WTF? This is getting crazy. The blackfin board Kconfig files are being
> used as a DT replacement. This can't go on.
>
Yes, it's a little too long. The scb patch is meant to be used for
user to tuning the performance of the on-chip(bf609) system crossbar
by menuconfig.

-steven

>                   Linus
