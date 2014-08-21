Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbaHUOWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:22:39 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:54507 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476AbaHUOWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:22:38 -0400
Date: Thu, 21 Aug 2014 09:22:35 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/slab_common: commonize slab merge logic
In-Reply-To: <1408608675-20420-2-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.11.1408210922020.32524@gentwo.org>
References: <1408608675-20420-1-git-send-email-iamjoonsoo.kim@lge.com> <1408608675-20420-2-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2014, Joonsoo Kim wrote:

> Slab merge is good feature to reduce fragmentation. Now, it is only
> applied to SLUB, but, it would be good to apply it to SLAB. This patch
> is preparation step to apply slab merge to SLAB by commonizing slab
> merge logic.

Oh. Wow. Never thought that would be possible. Need to have some more time
to review this though.
