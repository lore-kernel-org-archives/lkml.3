Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab3LCCKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:10:44 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52490 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3LCCKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:10:43 -0500
X-AuditID: 9c930197-b7c3dae000002c11-6e-529d3da16c42
Date: Tue, 3 Dec 2013 11:13:08 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] slab: make more slab management structure off the
 slab
Message-ID: <20131203021308.GE31168@lge.com>
References: <1385974183-31423-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1385974183-31423-6-git-send-email-iamjoonsoo.kim@lge.com>
 <00000142b3d18433-eacdc401-434f-42e1-8988-686bd15a3e20-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000142b3d18433-eacdc401-434f-42e1-8988-686bd15a3e20-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 02:58:41PM +0000, Christoph Lameter wrote:
> On Mon, 2 Dec 2013, Joonsoo Kim wrote:
> 
> > Now, the size of the freelist for the slab management diminish,
> > so that the on-slab management structure can waste large space
> > if the object of the slab is large.
> 
> Hmmm.. That is confusing to me. "Since the size of the freelist has shrunk
> significantly we have to adjust the heuristic for making the on/off slab
> placement decision"?
> 
> Make this clearer.

Yes. your understanding is right.
I will replace above line with yours.

Thanks.

> 
> Acked-by: Christoph Lameter <cl@linux.com>

