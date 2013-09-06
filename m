Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab3IFPtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:49:47 -0400
Received: from a194-110.smtp-out.amazonses.com ([199.255.194.110]:14984 "EHLO
	a194-110.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966Ab3IFPtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:49:46 -0400
Date: Fri, 6 Sep 2013 15:49:45 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH 2/4] slab: introduce helper functions to get/set
 free object
In-Reply-To: <1378447067-19832-3-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000140f3f6fe2d-ded4181c-05bf-47f9-8aa6-983102fdddc6-000000@email.amazonses.com>
References: <1378447067-19832-1-git-send-email-iamjoonsoo.kim@lge.com> <1378447067-19832-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Sep 2013, Joonsoo Kim wrote:

> In the following patches, to get/set free objects from the freelist
> is changed so that simple casting doesn't work for it. Therefore,
> introduce helper functions.

Acked-by: Christoph Lameter <cl@linux.com>
