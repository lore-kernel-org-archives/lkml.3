Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab3IFP7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:59:16 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:54185 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757355Ab3IFP7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:59:14 -0400
Date: Fri, 6 Sep 2013 15:59:12 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH 4/4] slab: make more slab management structure
 off the slab
In-Reply-To: <1378447067-19832-5-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000140f3ffa61e-035ca6ab-4931-407f-8a9d-0c60f6bb0357-000000@email.amazonses.com>
References: <1378447067-19832-1-git-send-email-iamjoonsoo.kim@lge.com> <1378447067-19832-5-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.06-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Sep 2013, Joonsoo Kim wrote:

> In a 64 byte sized slab case, no space is wasted if we use on-slab.
> So set off-slab determining constraint to 128 bytes.

Acked-by: Christoph Lameter <cl@linux.com>
