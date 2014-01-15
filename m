Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaAOFJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:09:23 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:37066 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaAOFJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:09:18 -0500
Date: Tue, 14 Jan 2014 21:09:15 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v3 5/5] slab: make more slab management structure off
 the slab
In-Reply-To: <1385974183-31423-6-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.02.1401142109050.7751@chino.kir.corp.google.com>
References: <1385974183-31423-1-git-send-email-iamjoonsoo.kim@lge.com> <1385974183-31423-6-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Dec 2013, Joonsoo Kim wrote:

> Now, the size of the freelist for the slab management diminish,
> so that the on-slab management structure can waste large space
> if the object of the slab is large.
> 
> Consider a 128 byte sized slab. If on-slab is used, 31 objects can be
> in the slab. The size of the freelist for this case would be 31 bytes
> so that 97 bytes, that is, more than 75% of object size, are wasted.
> 
> In a 64 byte sized slab case, no space is wasted if we use on-slab.
> So set off-slab determining constraint to 128 bytes.
> 
> Acked-by: Christoph Lameter <cl@linux.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: David Rientjes <rientjes@google.com>
