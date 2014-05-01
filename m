Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaEARK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 13:10:27 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48696 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaEARKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 13:10:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140501161005.GA6212@roeck-us.net>
References: <1397808515-8013-1-git-send-email-vgupta@synopsys.com>
	<1397808515-8013-3-git-send-email-vgupta@synopsys.com>
	<20140501161005.GA6212@roeck-us.net>
Date: Thu, 1 May 2014 10:10:24 -0700
X-Google-Sender-Auth: mYgPqjJS3bD69OQEHRTXVnztkfc
Message-ID: <CA+55aFwCOW+bZHfAYMJsFQqEiX7bE79B-JwcJxZ67UVtEQgpcA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Hexagon: Delete stale barrier.h
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 9:10 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>
> Hexagon build is still broken with 3.15-rc3 and with the latest upstream.
> This patch fixes the (build) problem. Would be great if the arch maintainer
> could apply this (or a similar) patch and send it to Linus.

I took it directly, since you compile-tested it.

             Linus
