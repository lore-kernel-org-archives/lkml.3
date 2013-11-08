Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab3KHTwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:52:41 -0500
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:48040 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758105Ab3KHTwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:52:39 -0500
Date: Fri, 8 Nov 2013 19:52:37 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] kmod: Run usermodehelpers only on cpus allowed for
 kthreadd V2
In-Reply-To: <20131108191235.GB12853@localhost.localdomain>
Message-ID: <000001423945fde3-f846f403-58b9-4acd-a2b8-43b62991ce02-000000@email.amazonses.com>
References: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com> <20131016141326.2e517e18e4d8af880c97a282@linux-foundation.org> <00000141c36b03b6-2f9bd3de-d153-4359-901f-084aeb4c040d-000000@email.amazonses.com>
 <20131017122344.39d55db97c3923131bdf2831@linux-foundation.org> <0000014233722db9-cc00d0af-a5fa-4090-83bd-73c87377b892-000000@email.amazonses.com> <20131107225049.GC28130@localhost.localdomain> <0000014238407a1c-34e7bdbc-45c0-48de-a8a3-94a99f276044-000000@email.amazonses.com>
 <20131108163112.GA12853@localhost.localdomain> <0000014238ad0fb9-aa252280-8e44-48ac-a096-e6dee26e09ea-000000@email.amazonses.com> <20131108191235.GB12853@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.11.08-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Nov 2013, Frederic Weisbecker wrote:

> I understand, but why not solving that from the workqueue affinity? We want to
> solve the issue of unbound workqueues in CPU isolation anyway.

Sure if you can solve that with an unbound work queue then this patch is
not needed. Do you have a patch that addresses this issue in your
patchset? How far out is the merging of that patch?

