Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762479Ab3JQTJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:09:44 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:54841 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762444Ab3JQTJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:09:43 -0400
Date: Thu, 17 Oct 2013 19:09:41 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 11/15] slab: remove SLAB_LIMIT
In-Reply-To: <1381913052-23875-12-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000141c7d2c80f-ddc771c0-b1be-4300-a264-a9a4bc6b686d-000000@email.amazonses.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com> <1381913052-23875-12-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.17-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Joonsoo Kim wrote:

> It's useless now, so remove it.

Acked-by: Christoph Lameter <cl@linux.com>
