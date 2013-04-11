Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762666Ab3DKWkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 18:40:42 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:38225 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759177Ab3DKWkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 18:40:40 -0400
Date: Thu, 11 Apr 2013 15:40:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Toshi Kani <toshi.kani@hp.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxram@us.ibm.com,
        guz.fnst@cn.fujitsu.com, tmac@hp.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, jiang.liu@huawei.com
Subject: Re: [PATCH] resource: Update config option of
 release_mem_region_adjustable()
In-Reply-To: <1365719185-4799-1-git-send-email-toshi.kani@hp.com>
Message-ID: <alpine.DEB.2.02.1304111540200.31420@chino.kir.corp.google.com>
References: <1365719185-4799-1-git-send-email-toshi.kani@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Apr 2013, Toshi Kani wrote:

> Changed the config option of release_mem_region_adjustable() from
> CONFIG_MEMORY_HOTPLUG to CONFIG_MEMORY_HOTREMOVE since this function
> is only used for memory hot-delete.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Suggested-by: David Rientjes <rientjes@google.com>
Acked-by: David Rientjes <rientjes@google.com>
