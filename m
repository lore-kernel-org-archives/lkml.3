Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3LCPaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:30:13 -0500
Received: from a9-113.smtp-out.amazonses.com ([54.240.9.113]:44310 "EHLO
	a9-113.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753279Ab3LCPaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:30:10 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 10:30:10 EST
Date: Tue, 3 Dec 2013 15:24:09 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/5] slab: introduce byte sized index for the freelist
 of a slab
In-Reply-To: <20131203022539.GF31168@lge.com>
Message-ID: <00000142b90f2d77-5ef1595b-9e59-4985-99a2-712699bb252e-000000@email.amazonses.com>
References: <1385974183-31423-1-git-send-email-iamjoonsoo.kim@lge.com> <1385974183-31423-5-git-send-email-iamjoonsoo.kim@lge.com> <20131203022539.GF31168@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.03-54.240.9.113
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can I get your ACK for this patch?

Sure.

Acked-by: Christoph Lameter <cl@linux.com>

