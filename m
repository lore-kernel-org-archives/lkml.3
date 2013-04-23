Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab3DWP6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:58:39 -0400
Received: from a9-66.smtp-out.amazonses.com ([54.240.9.66]:36671 "EHLO
	a9-66.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756718Ab3DWP6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:58:38 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Apr 2013 11:58:38 EDT
Date: Tue, 23 Apr 2013 15:51:10 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Aaron Tomlin <atomlin@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, penberg@kernel.org,
        Rik <riel@redhat.com>, Rafael Aquini <aquini@redhat.com>
Subject: Re: [Patch v2] mm: slab: Verify the nodeid passed to
 ____cache_alloc_node
In-Reply-To: <1014891011.990074.1366727496599.JavaMail.root@redhat.com>
Message-ID: <0000013e37976a8c-6e13fd72-1ae9-49e3-97fa-0fbb4dd3104d-000000@email.amazonses.com>
References: <1014891011.990074.1366727496599.JavaMail.root@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.23-54.240.9.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Apr 2013, Aaron Tomlin wrote:

> This patch is in response to BZ#42967 [1].
> Using VM_BUG_ON so it's used only when CONFIG_DEBUG_VM is set,
> given that ____cache_alloc_node() is a hot code path.

Acked-by: Christoph Lameter <cl@linux.com>
