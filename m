Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3DKUKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:10:24 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:43799 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab3DKUKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:10:20 -0400
Date: Thu, 11 Apr 2013 15:10:02 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: zsmalloc zbud hybrid design discussion?
Message-ID: <20130411201002.GD28296@cerebellum>
References: <ef105888-1996-4c78-829a-36b84973ce65@default>
 <20130411193534.GB28296@cerebellum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411193534.GB28296@cerebellum>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041120-3620-0000-0000-000001FF55E7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 02:35:34PM -0500, Seth Jennings wrote:
> Not a requirement:
> 
> Compaction - compaction would basically involve creating a virtual address
> space of sorts, which zsmalloc is capable of through its API with handles,
> not pointer.  However, as Dan points out this requires a structure the maintain
> the mappings and adds to complexity.  Additionally, the need for compaction
> diminishes as the allocations are short-lived with frontswap backends doing
> writeback and cleancache backends shrinking.

Of course I say this, but for zram, this can be important as the allocations
can't be moved out of memory and, therefore, are long lived.  I was speaking
from the zswap perspective.

Thanks,
Seth

