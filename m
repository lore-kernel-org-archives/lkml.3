Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3GAS67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:58:59 -0400
Received: from a9-54.smtp-out.amazonses.com ([54.240.9.54]:34864 "EHLO
	a9-54.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735Ab3GAS66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:58:58 -0400
X-Greylist: delayed 716 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2013 14:58:58 EDT
Date: Mon, 1 Jul 2013 18:47:00 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/slub: Use node_nr_slabs and node_nr_objs in
 get_slabinfo
In-Reply-To: <1372291059-9880-3-git-send-email-liwanp@linux.vnet.ibm.com>
Message-ID: <0000013f9b8f30b1-0126933f-98c9-4bf1-b475-daa3accd3724-000000@email.amazonses.com>
References: <1372291059-9880-1-git-send-email-liwanp@linux.vnet.ibm.com> <1372291059-9880-3-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.01-54.240.9.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013, Wanpeng Li wrote:

> Use existing interface node_nr_slabs and node_nr_objs to get
> nr_slabs and nr_objs.

Acked-by: Christoph Lameter <cl@linux.com>
