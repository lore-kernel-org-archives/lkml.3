Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab3FXVXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 17:23:14 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:57327 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3FXVXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 17:23:13 -0400
Date: Mon, 24 Jun 2013 14:23:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/slab: Sharing s_next and s_stop between slab and
 slub
In-Reply-To: <1372069394-26167-2-git-send-email-liwanp@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1306241421560.25343@chino.kir.corp.google.com>
References: <1372069394-26167-1-git-send-email-liwanp@linux.vnet.ibm.com> <1372069394-26167-2-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jun 2013, Wanpeng Li wrote:

> This patch shares s_next and s_stop between slab and slub.
> 

Just about the entire kernel includes slab.h, so I think you'll need to 
give these slab-specific names instead of exporting "s_next" and "s_stop" 
to everybody.
