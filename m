Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab3ILOQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:16:31 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45403 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3ILOQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:16:30 -0400
Date: Thu, 12 Sep 2013 16:16:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
Message-ID: <20130912141625.GA23357@somewhere>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
 <20130911220228.GB15367@somewhere>
 <000001411282afa6-fe9c0543-0447-492b-991e-dc8214884b88-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001411282afa6-fe9c0543-0447-492b-991e-dc8214884b88-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 02:10:56PM +0000, Christoph Lameter wrote:
> On Thu, 12 Sep 2013, Frederic Weisbecker wrote:
> 
> > Why not do this from userspace instead?
> 
> Because the cpumasks are hardcoded in the kernel code.
> 

Ok but you can change the affinity of a kthread from userspace, as
long as you define a cpu set that is among that kthread's cpus allowed.
