Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3CLN6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:58:10 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:56364 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3CLN6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:58:08 -0400
Date: Tue, 12 Mar 2013 14:58:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, "mingo@elte.hu" <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: Basic perf PMU support for Haswell v6
Message-ID: <20130312135803.GA21741@gmail.com>
References: <1360706658-13468-1-git-send-email-andi@firstfloor.org>
 <CABPqkBQQ6NuEdWFGjg1cU4VRWrYPFFYoegXmXfhwwFYQPUZOmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQQ6NuEdWFGjg1cU4VRWrYPFFYoegXmXfhwwFYQPUZOmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> Hi,
> 
> I am not seeing those patches in tip.git tree as of today.
> What is still wrong with those patches? I think they
> are good for providing the basic enablement for HSW.

There were still problems with them so they didn't make it
into v3.9 - now that the development window is open I'll check
the latest iteration (v9), in a couple of days.

Thanks,

	Ingo
