Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaDIFlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 01:41:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60034 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaDIFly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 01:41:54 -0400
Date: Wed, 9 Apr 2014 07:41:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Stancek <jstancek@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] futex: avoid race between requeue and wake
Message-ID: <20140409054139.GU10526@twins.programming.kicks-ass.net>
References: <b60ab13f8ae8fea64591670b017f1fe697cce7c9.1396945474.git.jstancek@redhat.com>
 <CA+55aFxCc2SON-aEz-nex=1yOi9HMCV5ued1G=Otwkw8jyHZ4A@mail.gmail.com>
 <CA+55aFyfKOv59hptv9rEcf31X5O8s26z+S8f-MchM1C0WtXx3A@mail.gmail.com>
 <20140408181305.GT10526@twins.programming.kicks-ass.net>
 <CA+55aFz+yMdXfsb-t3JzDhj6=M=-ggjDDGAQSbtfEcNhgyoopA@mail.gmail.com>
 <1860555101.1890107.1396990941681.JavaMail.zimbra@redhat.com>
 <CA+55aFzYwNde4ZyKgy_raRx9nz4+8he1-Fk9+_DDhWs-7fBbjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzYwNde4ZyKgy_raRx9nz4+8he1-Fk9+_DDhWs-7fBbjw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 03:30:07PM -0700, Linus Torvalds wrote:
> So I'll have to leave this decision to the futex people. But the
> attached slightly more complex patch *may* be the better one.

Of course, tglx is the main futex 'people' and he's not on CC.. *sigh*.
