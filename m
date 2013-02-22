Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab3BVQeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 11:34:50 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:36633 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757212Ab3BVQes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 11:34:48 -0500
Date: Fri, 22 Feb 2013 16:34:47 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v2] slub: correctly bootstrap boot caches
In-Reply-To: <1361550000-14173-1-git-send-email-glommer@parallels.com>
Message-ID: <0000013d02c1c9be-1a06ac46-e42b-4174-8a41-bc5b22ad36ad-000000@email.amazonses.com>
References: <1361550000-14173-1-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Glauber Costa wrote:

> After we create a boot cache, we may allocate from it until it is bootstraped.
> This will move the page from the partial list to the cpu slab list. If this
> happens, the loop:

Acked-by: Christoph Lameter <cl@linux.com>

