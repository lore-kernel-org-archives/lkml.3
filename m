Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbaDCXtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 19:49:04 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:34169 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbaDCXs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 19:48:58 -0400
Date: Fri, 4 Apr 2014 01:48:50 +0200
From: Rabin Vincent <rabin@rab.in>
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Alexander Holler <holler@ahsoftware.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] arm: don't allow CONFIG_DEBUG_SET_MODULE_RONX if
 CONFIG_JUMP_LABEL is enabled
Message-ID: <20140403234850.GA13956@debian>
References: <1396346657-7166-1-git-send-email-holler@ahsoftware.de>
 <533AFF77.5030106@codeaurora.org>
 <CAGXu5jKMF9n9svQBhyQFvCoUe86QhLycDTt-fWyiRfySbn=Fug@mail.gmail.com>
 <CAH+eYFDkYczZXYF3be6tTRg7kkGhK2zyukDTo+N8mwEKcG89LA@mail.gmail.com>
 <CAGXu5jKyzbRR4S0+0daygWcE2-BbFi1X6MFAkPqTNbGiT6huSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKyzbRR4S0+0daygWcE2-BbFi1X6MFAkPqTNbGiT6huSQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 04:14:54PM -0700, Kees Cook wrote:
> On Tue, Apr 1, 2014 at 4:08 PM, Rabin Vincent <rabin@rab.in> wrote:
> > Here's a patch (probably whitespace damaged, hence also attached) with
> > which dynamic ftrace works for me on top your other paches.  Tested on
> > a non-LPAE SMP.
> 
> Thanks! I'll incorporate calls to set_all_modules_text_rw/ro and see
> what I can make work.

You can use the patch I posted yesterday for module support:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/244558.html
