Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab3KHUG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 15:06:26 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61613 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478Ab3KHUGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 15:06:25 -0500
Date: Fri, 8 Nov 2013 21:06:22 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] kmod: Run usermodehelpers only on cpus allowed for
 kthreadd V2
Message-ID: <20131108200620.GC14606@localhost.localdomain>
References: <20131016141326.2e517e18e4d8af880c97a282@linux-foundation.org>
 <00000141c36b03b6-2f9bd3de-d153-4359-901f-084aeb4c040d-000000@email.amazonses.com>
 <20131017122344.39d55db97c3923131bdf2831@linux-foundation.org>
 <0000014233722db9-cc00d0af-a5fa-4090-83bd-73c87377b892-000000@email.amazonses.com>
 <20131107225049.GC28130@localhost.localdomain>
 <0000014238407a1c-34e7bdbc-45c0-48de-a8a3-94a99f276044-000000@email.amazonses.com>
 <20131108163112.GA12853@localhost.localdomain>
 <0000014238ad0fb9-aa252280-8e44-48ac-a096-e6dee26e09ea-000000@email.amazonses.com>
 <20131108191235.GB12853@localhost.localdomain>
 <000001423945fde3-f846f403-58b9-4acd-a2b8-43b62991ce02-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001423945fde3-f846f403-58b9-4acd-a2b8-43b62991ce02-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 07:52:37PM +0000, Christoph Lameter wrote:
> On Fri, 8 Nov 2013, Frederic Weisbecker wrote:
> 
> > I understand, but why not solving that from the workqueue affinity? We want to
> > solve the issue of unbound workqueues in CPU isolation anyway.
> 
> Sure if you can solve that with an unbound work queue then this patch is
> not needed. Do you have a patch that addresses this issue in your
> patchset?

No. Sorry.

> How far out is the merging of that patch?
