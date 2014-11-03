Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaKCSFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:05:34 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:52417 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaKCSFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:05:32 -0500
MIME-Version: 1.0
In-Reply-To: <20141103175633.GC15689@arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
	<1414496662-25202-2-git-send-email-will.deacon@arm.com>
	<CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
	<CA+55aFwpOCeXdThX3zB64AU4hFwufD6UdJDi2tkD8Q7yEV2pOA@mail.gmail.com>
	<20141029194738.GA29911@arm.com>
	<CA+55aFxoQSm5ko8bQxPd8usXxaZy_RgGpv36PTiEzYaWcOiwTA@mail.gmail.com>
	<1414618065.4257.21.camel@pasglop>
	<CA+55aFwZDQgfjMuftKF0TeMwV-uU=4SgJNfH+u4MyQ_UgfiFEg@mail.gmail.com>
	<20141103175633.GC15689@arm.com>
Date: Mon, 3 Nov 2014 10:05:31 -0800
X-Google-Sender-Auth: URF-hgJjwszMlk3UfCk_5UwdmnQ
Message-ID: <CA+55aFy+HDwk0uMq9CAwmm59sZ--GZER0fxg8f0QuUXHiSU5sQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 9:56 AM, Will Deacon <will.deacon@arm.com> wrote:
>
> We use `tlb->end > 0' in the arm64 backend, so I think you're right. I'll
> take a look in the name of cleanup and this can wait until 3.19.

Ok, I'll just archive this thread for now, and expect a patch at some
future date. And as far as I'm concerned, it's ok if it just comes in
through the normal arm64 tree, with just a note in the pull request
reminding me about why it also touches some other architectures.

Thanks,

                     Linus
