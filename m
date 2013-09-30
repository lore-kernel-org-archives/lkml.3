Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab3I3PuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:50:07 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:39982 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab3I3PuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:50:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130930152242.207382649@infradead.org>
References: <20130930152242.207382649@infradead.org>
Date: Mon, 30 Sep 2013 08:50:04 -0700
X-Google-Sender-Auth: gausFJV2sjO_LsZINiOkc4Btt7c
Message-ID: <CA+55aFzs-+2HCAjxU=7FJ-1+q1hnDADJ_rzTRdMuDrzzYAVstw@mail.gmail.com>
Subject: Re: [PATCH 0/6] sched, wait: Collapse __wait_event macros -v4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 8:22 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Compile and boot tested on x86_64.

Btw, I assume the odd binary size reduction is gone now, and code
generation is generally identical?

                 Linus
