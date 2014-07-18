Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422748AbaGRSBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:01:16 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:64260 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030529AbaGRSBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:01:15 -0400
Date: Fri, 18 Jul 2014 14:01:10 -0400
From: Tejun Heo <tj@kernel.org>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] Memoryless nodes and kworker
Message-ID: <20140718180110.GD13012@htj.dyndns.org>
References: <20140717230923.GA32660@linux.vnet.ibm.com>
 <20140718112039.GA8383@htj.dyndns.org>
 <CAOhV88PyBK3WxDjG1H0hUbRhRYzPOzV8eim5DuOcgObe-FtFYg@mail.gmail.com>
 <20140718180008.GC13012@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718180008.GC13012@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 02:00:08PM -0400, Tejun Heo wrote:
> This isn't a huge issue but it shows that this is the wrong layer to
> deal with this issue.  Let the allocators express where they are.
                                 ^
				 allocator users
> Choosing and falling back belong to the memory allocator.  That's the
> only place which has all the information that's necessary and those
> details must be contained there.  Please don't leak it to memory
> allocator users.

-- 
tejun
