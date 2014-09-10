Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaIJPnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:43:55 -0400
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:49483 "EHLO
	resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064AbaIJPny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:43:54 -0400
Date: Wed, 10 Sep 2014 10:43:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jiri Kosina <jkosina@suse.cz>
cc: "Theodore Ts'o" <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers
In-Reply-To: <alpine.LNX.2.00.1409101613500.5523@pobox.suse.cz>
Message-ID: <alpine.DEB.2.11.1409101042230.1654@gentwo.org>
References: <alpine.LNX.2.00.1409092319370.5523@pobox.suse.cz> <20140909162114.44b3e98cf925f125e84a8a06@linux-foundation.org> <alpine.LNX.2.00.1409100702190.5523@pobox.suse.cz> <20140910140759.GC31903@thunk.org>
 <alpine.LNX.2.00.1409101613500.5523@pobox.suse.cz>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Jiri Kosina wrote:

> Still, I believe that kernel shouldn't be just ignoring kfree(ERR_PTR)
> happening. Would something like the below be more acceptable?

CONFIG_DEBUG_SLAB is the wrong debugging option since it is used for
object debugging. This kind of patch would need CONFIG_DEBUG_VM I think.

