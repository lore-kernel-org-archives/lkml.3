Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbaHYP2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 11:28:05 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:50585 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756046AbaHYP2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 11:28:01 -0400
Date: Mon, 25 Aug 2014 10:27:58 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/slab_common: commonize slab merge logic
In-Reply-To: <1408608675-20420-2-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.11.1408251026110.27302@gentwo.org>
References: <1408608675-20420-1-git-send-email-iamjoonsoo.kim@lge.com> <1408608675-20420-2-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2014, Joonsoo Kim wrote:

> +static int __init setup_slab_nomerge(char *str)
> +{
> +	slab_nomerge = 1;
> +	return 1;
> +}
> +__setup("slub_nomerge", setup_slab_nomerge);

Uhh.. You would have to specify "slub_nomerge" to get slab to not merge
slab caches?

Otherwise this is a straightforward move into the common area.

