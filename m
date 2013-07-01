Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3GASlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:41:08 -0400
Received: from a9-66.smtp-out.amazonses.com ([54.240.9.66]:39123 "EHLO
	a9-66.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754617Ab3GASlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:41:06 -0400
Date: Mon, 1 Jul 2013 18:41:04 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
cc: penberg@kernel.org, mpm@selenic.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: add kmalloc() to kernel API documentation
In-Reply-To: <1372177015-30492-1-git-send-email-michael.opdenacker@free-electrons.com>
Message-ID: <0000013f9b89c37f-5d9539bc-944c-4937-9b35-30cdd0fd18a3-000000@email.amazonses.com>
References: <1372177015-30492-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.01-54.240.9.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jun 2013, Michael Opdenacker wrote:

> This patch is a proposed fix for this. It also removes the documentation
> for kmalloc() in include/linux/slob_def.h which isn't included to
> generate the documentation anyway. This way, kmalloc() is described
> in only one place.

Acked-by: Christoph Lameter <cl@linux.com>

Note that this will conflict with one of my pending patches that also
addresses one of these issues but this work is much more comprehensive.
