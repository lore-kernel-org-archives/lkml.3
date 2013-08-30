Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab3H3Vs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 17:48:57 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:55633 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3H3Vsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 17:48:55 -0400
Date: Fri, 30 Aug 2013 14:48:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jianguo Wu <wujianguo@huawei.com>
cc: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mingo@redhat.com
Subject: Re: [PATCH 3/4] x86/srat: use NUMA_NO_NODE
In-Reply-To: <521FF57A.8080702@huawei.com>
Message-ID: <alpine.DEB.2.02.1308301448440.29484@chino.kir.corp.google.com>
References: <521FF57A.8080702@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Aug 2013, Jianguo Wu wrote:

> setup_node() return NUMA_NO_NODE or valid node id(>=0), So use more appropriate
> "if (node == NUMA_NO_NODE)" instead of "if (node < 0)"
> 
> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>

Acked-by: David Rientjes <rientjes@google.com>
