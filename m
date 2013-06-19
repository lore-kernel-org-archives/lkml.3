Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab3FSOZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:25:48 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:47332 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756731Ab3FSOZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:25:47 -0400
Date: Wed, 19 Jun 2013 14:25:46 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: do not put a slab to cpu partial list when
 cpu_partial is 0
In-Reply-To: <1371623635-26575-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <0000013f5cd3b621-8f7f97fb-f97e-4498-9e1e-40feaa7be0b7-000000@email.amazonses.com>
References: <1371623635-26575-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.06.19-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jun 2013, Joonsoo Kim wrote:

> In free path, we don't check number of cpu_partial, so one slab can
> be linked in cpu partial list even if cpu_partial is 0. To prevent this,
> we should check number of cpu_partial in put_cpu_partial().

Acked-by: Christoph Lameeter <cl@linux.com>

