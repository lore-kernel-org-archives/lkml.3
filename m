Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3LJV7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:59:35 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:44259 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3LJV7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:59:31 -0500
MIME-Version: 1.0
In-Reply-To: <20131210215618.GA5050@redhat.com>
References: <20131210154724.GA30020@redhat.com>
	<CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
	<alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
	<CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
	<20131210203559.GA1209@redhat.com>
	<20131210204925.GB27373@redhat.com>
	<1386709583.3685.78.camel@dvhart-mobl4.amr.corp.intel.com>
	<CA+55aFx1Eech-MXWgJkERjJPSeg_9HVyLo_8nz=saNJyNmS7Kg@mail.gmail.com>
	<20131210213201.GF27373@redhat.com>
	<CA+55aFzkoqH5d3Ya9adqdmgZgZEsuZqTFfevor5k6M99HMF9=Q@mail.gmail.com>
	<20131210215618.GA5050@redhat.com>
Date: Tue, 10 Dec 2013 13:59:30 -0800
X-Google-Sender-Auth: et7QX3D8T6FsRbYLYezNfy8_9Oo
Message-ID: <CA+55aFyMS7HOq8WHqctqVyQmcseP2AVqut9rgRKu-uZEsBNpxQ@mail.gmail.com>
Subject: Re: process 'stuck' at exit.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 1:56 PM, Dave Jones <davej@redhat.com> wrote:
>
> Hmm, the only vmlinux I have still around is newer than the running kernel,
> so that's not going to be much help.

Ok, /proc/kallsyms would do it, but never mind. I think you already
pinpointed where the loop is with the trace file, so no need for
trying to decode the profile.

            Linus
