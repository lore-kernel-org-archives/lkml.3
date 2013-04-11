Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177Ab3DKWnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 18:43:55 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:3921 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3DKWny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 18:43:54 -0400
Message-ID: <1365719494.32127.119.camel@misato.fc.hp.com>
Subject: Re: [PATCH] resource: Update config option of
 release_mem_region_adjustable()
From: Toshi Kani <toshi.kani@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxram@us.ibm.com,
        guz.fnst@cn.fujitsu.com, tmac@hp.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, jiang.liu@huawei.com
Date: Thu, 11 Apr 2013 16:31:34 -0600
In-Reply-To: <alpine.DEB.2.02.1304111540200.31420@chino.kir.corp.google.com>
References: <1365719185-4799-1-git-send-email-toshi.kani@hp.com>
	 <alpine.DEB.2.02.1304111540200.31420@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 15:40 -0700, David Rientjes wrote:
> On Thu, 11 Apr 2013, Toshi Kani wrote:
> 
> > Changed the config option of release_mem_region_adjustable() from
> > CONFIG_MEMORY_HOTPLUG to CONFIG_MEMORY_HOTREMOVE since this function
> > is only used for memory hot-delete.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> 
> Suggested-by: David Rientjes <rientjes@google.com>
> Acked-by: David Rientjes <rientjes@google.com>

Thanks David!
-Toshi

