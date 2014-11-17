Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaKQTpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:45:08 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:63397 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaKQTpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:45:07 -0500
Date: Mon, 17 Nov 2014 11:45:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Linux MM <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org, wangnan0@huawei.com
Subject: Re: [PATCH] memory-hotplug: remove redundant call of page_to_pfn
In-Reply-To: <5461D343.60803@huawei.com>
Message-ID: <alpine.DEB.2.10.1411171144550.25623@chino.kir.corp.google.com>
References: <1415697184-26409-1-git-send-email-zhenzhang.zhang@huawei.com> <5461D343.60803@huawei.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014, Zhang Zhen wrote:

> The start_pfn can be obtained directly by
> phys_index << PFN_SECTION_SHIFT.
> 
> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>

Acked-by: David Rientjes <rientjes@google.com>
