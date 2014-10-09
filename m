Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaJIDuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 23:50:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbaJIDua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 23:50:30 -0400
Date: Wed, 8 Oct 2014 23:49:55 -0400
From: Dave Jones <davej@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: hrtimer deadlock caused by nohz_full
Message-ID: <20141009034955.GA30661@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20140925141425.GA21702@redhat.com>
 <alpine.DEB.2.10.1409251630210.4604@nanos>
 <20140925234657.GB14870@lerouge>
 <20141002182409.GA29934@redhat.com>
 <20141007153024.GA14119@lerouge>
 <20141007173730.GA12147@redhat.com>
 <alpine.DEB.2.11.1410071942100.4292@nanos>
 <20141009020240.GA14090@redhat.com>
 <20141009033017.GA24907@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009033017.GA24907@lerouge>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 05:30:20AM +0200, Frederic Weisbecker wrote:

 > > Do I miss some other essential patch ?
 > 
 > If you have used the diff in that URL then you've missed:
 > 
 >      x86: Tell irq work about self IPI support
 > 
 > Without that the whole patchset has no effect.

Ok. Thanks, I'll rerun with that.

	Dave

