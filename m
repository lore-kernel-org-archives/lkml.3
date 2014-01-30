Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751005AbaA3GOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 01:14:55 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:39323 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaA3GOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 01:14:54 -0500
Message-ID: <1391062491.28432.68.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] kthread: ensure locality of task_struct allocations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>, Eric Dumazet <edumazet@google.com>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Jan Kara <jack@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 29 Jan 2014 22:14:51 -0800
In-Reply-To: <alpine.DEB.2.02.1401291622550.22974@chino.kir.corp.google.com>
References: <20140128183808.GB9315@linux.vnet.ibm.com>
	 <alpine.DEB.2.02.1401290012460.10268@chino.kir.corp.google.com>
	 <alpine.DEB.2.10.1401290957350.23856@nuc>
	 <alpine.DEB.2.02.1401291622550.22974@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-29 at 16:27 -0800, David Rientjes wrote:

> Eric, did you try this when writing 207205a2ba26 ("kthread: NUMA aware 
> kthread_create_on_node()") or was it always numa_node_id() from the 
> beginning?

Hmm, I think I did not try this, its absolutely possible NUMA_NO_NODE
was better here.



