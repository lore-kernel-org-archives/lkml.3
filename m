Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbaGUQwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:52:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:56156 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679AbaGUQwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:52:17 -0400
Date: Mon, 21 Jul 2014 18:52:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Bruno Wolff III <bruno@wolff.to>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140721165212.GO3935@laptop>
References: <20140717090452.GH19379@twins.programming.kicks-ass.net>
 <53C7B247.2070309@arm.com>
 <20140717123502.GL19379@twins.programming.kicks-ass.net>
 <20140718053449.GA2039@wolff.to>
 <20140718101633.GP9918@twins.programming.kicks-ass.net>
 <20140718130126.GA2401@wolff.to>
 <20140718141648.GE20603@laptop.programming.kicks-ass.net>
 <20140718145040.GG12054@laptop.lan>
 <20140718161602.GH12054@laptop.lan>
 <20140721163528.GA10433@wolff.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721163528.GA10433@wolff.to>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 11:35:28AM -0500, Bruno Wolff III wrote:
> Is there more I can do to help with this now? Or should I just wait for
> patches to test?

Yeah, sorry, was wiped out today. I'll go stare harder at the P4
topology setup code tomorrow. Something fishy there.
