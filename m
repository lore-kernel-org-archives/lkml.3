Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab3CARH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:07:57 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:58222 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3CARH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:07:56 -0500
MIME-Version: 1.0
In-Reply-To: <20130301165043.GB5435@kroah.com>
References: <20130213111007.GA11367@gmail.com>
	<CA+55aFxrjsVkBwUdjmc4MYvEsjEyCJZ7AFpGrWvbbQFB3EVtHA@mail.gmail.com>
	<alpine.LFD.2.02.1302140012460.22263@ionos>
	<20130214144510.GC25282@gmail.com>
	<20130214145424.GA26071@gmail.com>
	<20130214150810.GA26095@gmail.com>
	<CAE9FiQXc=7+TMwbfd20YiHNfOHX_kUOzYcVm8-uaP2R_C_1RRg@mail.gmail.com>
	<20130215114425.GD26955@gmail.com>
	<20130215220615.GA1696@kroah.com>
	<20130216082954.GA18953@gmail.com>
	<20130301165043.GB5435@kroah.com>
Date: Fri, 1 Mar 2013 09:07:52 -0800
X-Google-Sender-Auth: ebg6dvCG7SnZH2NcEbys3tMmLpI
Message-ID: <CA+55aFzxbC_+FeKW8Kpnu3Kj=rpn94DXcjtr1Mw3OPXamVQ=hA@mail.gmail.com>
Subject: Re: [-rc7 regression] Buggy commit: "mm: use aligned zone start for
 pfn_to_bitidx calculation"
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Laura Abbott <lauraa@codeaurora.org>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 8:50 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> What ever happened with this?  Did something go into Linus's tree to
> resolve this issue that I need to pull into a stable release?

This was fixed by commit 7c45512df987 ("mm: fix pageblock bitmap allocation").

And you already put it in, afaik.

          Linus
