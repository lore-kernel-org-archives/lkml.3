Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402Ab3BYJLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 04:11:46 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:52599 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932Ab3BYJLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 04:11:44 -0500
Date: Mon, 25 Feb 2013 04:11:37 -0500 (EST)
From: Aaron Tomlin <atomlin@redhat.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Rik <riel@redhat.com>
Message-ID: <1972662987.7786576.1361783497483.JavaMail.root@redhat.com>
In-Reply-To: <512775CA.2030603@parallels.com>
Subject: Re: [PATCH] mm: slab: Verify the nodeid passed to
 ____cache_alloc_node
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.33.1.237]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC24 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you assert with VM_BUG_ON, it will be active on debugging kernels
> only, which I believe is better suited for a hotpath.

Agreed.

Regards,
Aaron
