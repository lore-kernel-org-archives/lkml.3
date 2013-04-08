Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab3DHEtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:49:31 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:35429 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab3DHEta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:49:30 -0400
MIME-Version: 1.0
In-Reply-To: <51624591.4010303@synopsys.com>
References: <alpine.LFD.2.02.1304031433350.21884@ionos>
	<1364998282-21437-1-git-send-email-vgupta@synopsys.com>
	<20130404152808.GB15261@ab42.lan>
	<515E54BD.2090300@synopsys.com>
	<51602459.3040105@synopsys.com>
	<CA+55aFw=-oJxujka-emxyRcY54MSe3qEjZ6xgzoE-roe3EFk5g@mail.gmail.com>
	<51624591.4010303@synopsys.com>
Date: Sun, 7 Apr 2013 21:49:28 -0700
X-Google-Sender-Auth: hFy8MMwKa5Cz8RaRVCFYWaGvZB8
Message-ID: <CA+55aFwLyS_Y1h73CgW1xwRQC6zHE9wgq9UDHGKLhBPUasACbQ@mail.gmail.com>
Subject: Re: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for !PREEMPT_COUNT
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 7, 2013 at 9:20 PM, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>
> Would you be OK if I send the single patch to ARC by email (for 3.9-rc7) or you'd
> rather have the pull request.

I got distracted by thinking about user-accesses vs preemption, but
yes, sending the ARC patch to fix things by email as a plain patch is
fine.

             Linus
