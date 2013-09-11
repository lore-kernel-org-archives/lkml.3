Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3IKOf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:35:28 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:58160 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753373Ab3IKOf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:35:27 -0400
Date: Wed, 11 Sep 2013 14:35:25 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/16] slab: put forward freeing slab management object
In-Reply-To: <1377161065-30552-7-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <000001410d72beda-2c38b76c-3962-45fc-9d16-99452dbd7edc-000000@email.amazonses.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com> <1377161065-30552-7-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.11-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013, Joonsoo Kim wrote:

> We don't need to free slab management object in rcu context,
> because, from now on, we don't manage this slab anymore.
> So put forward freeing.

Acked-by: Christoph Lameter <cl@linux.com>
