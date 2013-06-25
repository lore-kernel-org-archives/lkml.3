Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3FYSky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:40:54 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:59170 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab3FYSkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:40:51 -0400
MIME-Version: 1.0
In-Reply-To: <51C9DEC1.6030602@zytor.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
	<20130621165142.GA32125@kroah.com>
	<51C48745.9030304@zytor.com>
	<CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com>
	<20130621185056.GA23473@kroah.com>
	<51C4C5F3.3050800@sgi.com>
	<CAE9FiQXaUNbK9+g-7j6gfvLrSvUJFWWKapDv658LPe4VfbH=tQ@mail.gmail.com>
	<51C9D4ED.5070805@sgi.com>
	<51C9DEC1.6030602@zytor.com>
Date: Tue, 25 Jun 2013 11:40:50 -0700
X-Google-Sender-Auth: qSwOujc_4rdTKxrnf72eurq62LY
Message-ID: <CAE9FiQV5z+3AXy5c=aaU3vq1V3fibJ6PhhA4VW5H8BWVzhxXPA@mail.gmail.com>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Travis <travis@sgi.com>, Greg KH <gregkh@linuxfoundation.org>,
        Nathan Zimmer <nzimmer@sgi.com>, Robin Holt <holt@sgi.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 11:17 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/25/2013 10:35 AM, Mike Travis wrote:

> However, please consider Ingo's counterproposal of doing this via the
> buddy allocator, i.e. hugepages being broken on demand.  That is a
> *very* powerful model, although would require more infrastructure.

Can you or Ingo elaborate more about the buddy allocator proposal?

Thanks
