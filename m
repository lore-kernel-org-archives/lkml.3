Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaHDPAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:00:43 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:52576
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753103AbaHDPAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:00:42 -0400
Date: Mon, 4 Aug 2014 10:00:39 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Sasha Levin <sasha.levin@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Matt Mackall <mpm@selenic.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
        Jens Axboe <axboe@fb.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: kernel: smp: WARNING at kernel/smp.c:673
In-Reply-To: <53DEF67E.8090004@oracle.com>
Message-ID: <alpine.DEB.2.11.1408041000040.8248@gentwo.org>
References: <53DEF67E.8090004@oracle.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Aug 2014, Sasha Levin wrote:

> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel, I've stumbled on the following spew:

Hmmm... Is this the new cpuset code that calling kmem_cache_shrink from
the cpu notifier?

TJ?

