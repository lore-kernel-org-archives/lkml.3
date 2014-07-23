Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbaGWIjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:39:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986AbaGWIjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:39:49 -0400
Date: Wed, 23 Jul 2014 10:39:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: PANIC: ata_qc_new_init crashes at boot
Message-ID: <20140723083937.GA3416@twins.programming.kicks-ass.net>
References: <CAEuXFEy5=0XkqPiWQNiGbpi5EHSzq5f_U7Sj0t2bhO_1Lqe5vw@mail.gmail.com>
 <53CEBFF2.7050100@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CEBFF2.7050100@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 03:48:02PM -0400, Peter Hurley wrote:
> [ +cc Tejun ]
> 
> On 07/22/2014 03:26 PM, Jesse Brandeburg wrote:
> > This is a repeatable panic, happens every boot (and prevents starting my system)
> > 
> > 
> > 
> > [    8.732993] sd 6:0:1:0: [sdb] Attached SCSI disk
> > [    8.733857]  sda: sda1 sda2 sda3
> > [    8.734318] sd 6:0:0:0: [sda] Attached SCSI disk
> > [    8.737943] BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
> > [    8.737947] IP: [<ffffffff814e0618>] ata_qc_new_init+0x188/0x1b0

I too have this problem on one of my machines. Let me know if there's
anything you need.
