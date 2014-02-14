Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaBNSsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:48:32 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:33497 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752679AbaBNSsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:48:30 -0500
Date: Fri, 14 Feb 2014 12:48:28 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 8/9] slab: destroy a slab without holding any alien cache
 lock
In-Reply-To: <1392361043-22420-9-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.10.1402141247590.12887@nuc>
References: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com> <1392361043-22420-9-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014, Joonsoo Kim wrote:

> I haven't heard that this alien cache lock is contended, but to reduce
> chance of contention would be better generally. And with this change,
> we can simplify complex lockdep annotation in slab code.
> In the following patch, it will be implemented.

Ok. Same move as before with the regular freeing.

Acked-by: Christoph Lameter <cl@linux.com>
