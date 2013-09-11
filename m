Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3IKOSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:18:01 -0400
Received: from a9-99.smtp-out.amazonses.com ([54.240.9.99]:37517 "EHLO
	a9-99.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753431Ab3IKOSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:18:00 -0400
Date: Wed, 11 Sep 2013 14:17:57 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joe Perches <joe@perches.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: Make allocations with GFP_ZERO slightly more
 efficient
In-Reply-To: <1378857771.15187.4.camel@joe-AO722>
Message-ID: <000001410d62c020-44437965-d471-4125-af3c-cfd19b393de8-000000@email.amazonses.com>
References: <1378857771.15187.4.camel@joe-AO722>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.11-54.240.9.99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, Joe Perches wrote:

> Use the likely mechanism already around valid
> pointer tests to better choose when to memset
> to 0 allocations with __GFP_ZERO

Ok but that is not that important since the first ptr check is only for
debuggin.

Acked-by: Christoph Lameter <cl@linux.com>
