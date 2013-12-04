Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab3LDPVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:21:22 -0500
Received: from b232-131.smtp-out.amazonses.com ([199.127.232.131]:22190 "EHLO
	b232-131.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932609Ab3LDPVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:21:20 -0500
Date: Wed, 4 Dec 2013 15:21:19 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 2/8] mm, mempolicy: rename slab_node for clarity
In-Reply-To: <alpine.DEB.2.02.1312032117330.29733@chino.kir.corp.google.com>
Message-ID: <00000142be32f445-c4b31577-3ad8-42c4-bfd5-6387662ffa70-000000@email.amazonses.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com> <20131120152251.GA18809@dhcp22.suse.cz> <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
 <20131128115458.GK2761@dhcp22.suse.cz> <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com> <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com> <alpine.DEB.2.02.1312032117330.29733@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.131
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, David Rientjes wrote:

> slab_node() is actually a mempolicy function, so rename it to
> mempolicy_slab_node() to make it clearer that it used for processes with
> mempolicies.

Acked-by: Christoph Lameter <cl@linux.com>
