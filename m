Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3LJVtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:49:21 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52763 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3LJVtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:49:20 -0500
MIME-Version: 1.0
In-Reply-To: <20131210213201.GF27373@redhat.com>
References: <20131210154724.GA30020@redhat.com>
	<CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
	<alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
	<CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
	<20131210203559.GA1209@redhat.com>
	<20131210204925.GB27373@redhat.com>
	<1386709583.3685.78.camel@dvhart-mobl4.amr.corp.intel.com>
	<CA+55aFx1Eech-MXWgJkERjJPSeg_9HVyLo_8nz=saNJyNmS7Kg@mail.gmail.com>
	<20131210213201.GF27373@redhat.com>
Date: Tue, 10 Dec 2013 13:49:19 -0800
X-Google-Sender-Auth: O1qAj0fGvY9oCRzQ6r6_aRXzQlY
Message-ID: <CA+55aFzkoqH5d3Ya9adqdmgZgZEsuZqTFfevor5k6M99HMF9=Q@mail.gmail.com>
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

On Tue, Dec 10, 2013 at 1:32 PM, Dave Jones <davej@redhat.com> wrote:
>
> http://www.codemonkey.org.uk/junk/perf.data.xz

 "Forbidden

  You don't have permission to access /junk/perf.data.xz on this server."

also, we'd need the vmlinux file to actually decode the data, I think.

              Linus
