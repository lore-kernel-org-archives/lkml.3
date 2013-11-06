Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3KFTWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:22:01 -0500
Received: from smtp161.dfw.emailsrvr.com ([67.192.241.161]:53028 "EHLO
	smtp161.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab3KFTWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:22:00 -0500
Date: Wed, 6 Nov 2013 20:21:54 +0100
From: Andreas Herrmann <andreas.herrmann@calxeda.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/slub: Switch slub_debug kernel option to early_param
 to avoid boot panic
Message-ID: <20131106192154.GG5661@alberich>
References: <20131106184529.GB5661@alberich>
 <000001422ed8406b-14bef091-eee0-4e0e-bcdd-a8909c605910-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <000001422ed8406b-14bef091-eee0-4e0e-bcdd-a8909c605910-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 02:16:33PM -0500, Christoph Lameter wrote:
> On Wed, 6 Nov 2013, Andreas Herrmann wrote:
> 
> > When I've used slub_debug kernel option (e.g.
> > "slub_debug=,skbuff_fclone_cache" or similar) on a debug session I've
> > seen a panic like:
> 
> Hmmm.. That looks like its due to some slabs not having names
> during early boot. kmem_cache_flags is called with NULL as a parameter.
> 
> Are you sure that this fixes the issue?

?

Sure, of course I've tested my patch as I required slub debugging.
Panic was gone and debugging of the selected slab enabled.


Andreas
