Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaJYUYd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 16:24:33 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62753 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaJYUYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 16:24:32 -0400
Date: Sat, 25 Oct 2014 11:15:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: vmalloced stacks on x86_64?
Message-ID: <20141025091537.GA11433@gmail.com>
References: <CALCETrUmA+5499fEqp7S-nfSBVxTEo76mA9r32zYQ41E3c+YhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUmA+5499fEqp7S-nfSBVxTEo76mA9r32zYQ41E3c+YhQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> Is there any good reason not to use vmalloc for x86_64 stacks?

In addition to what hpa mentioned, __pa()/__va() on-kstack DMA 
gets tricky, for legacy drivers. (Not sure how many of these are 
left though.)

Thanks,

	Ingo
