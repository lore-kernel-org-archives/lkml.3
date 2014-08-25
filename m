Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbaHYI0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:26:51 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44761 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbaHYI0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:26:50 -0400
X-Original-SENDERIP: 10.177.222.131
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 25 Aug 2014 17:26:54 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/slab_common: commonize slab merge logic
Message-ID: <20140825082654.GB13475@js1304-P5Q-DELUXE>
References: <1408608675-20420-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1408608675-20420-2-git-send-email-iamjoonsoo.kim@lge.com>
 <alpine.DEB.2.11.1408210922020.32524@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1408210922020.32524@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 09:22:35AM -0500, Christoph Lameter wrote:
> On Thu, 21 Aug 2014, Joonsoo Kim wrote:
> 
> > Slab merge is good feature to reduce fragmentation. Now, it is only
> > applied to SLUB, but, it would be good to apply it to SLAB. This patch
> > is preparation step to apply slab merge to SLAB by commonizing slab
> > merge logic.
> 
> Oh. Wow. Never thought that would be possible. Need to have some more time
> to review this though.

Yes, please review it. :)

Thanks.
