Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab3IKOby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:31:54 -0400
Received: from a9-66.smtp-out.amazonses.com ([54.240.9.66]:44359 "EHLO
	a9-66.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754469Ab3IKObx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:31:53 -0400
Date: Wed, 11 Sep 2013 14:31:51 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/16] slab: change return type of kmem_getpages() to
 struct page
In-Reply-To: <1377161065-30552-3-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <000001410d6f7625-f84563e7-091f-4a83-b722-3f20d32c5b56-000000@email.amazonses.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com> <1377161065-30552-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.11-54.240.9.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013, Joonsoo Kim wrote:

> It is more understandable that kmem_getpages() return struct page.
> And, with this, we can reduce one translation from virt addr to page and
> makes better code than before. Below is a change of this patch.

Acked-by: Christoph Lameter <cl@linux.com>
