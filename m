Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab3DKXze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:55:34 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:26290 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3DKXzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:55:33 -0400
Message-ID: <1365723793.32127.120.camel@misato.fc.hp.com>
Subject: Re: [PATCH] resource: Update config option of
 release_mem_region_adjustable()
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rientjes@google.com, linuxram@us.ibm.com,
        guz.fnst@cn.fujitsu.com, tmac@hp.com, wency@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, jiang.liu@huawei.com
Date: Thu, 11 Apr 2013 17:43:13 -0600
In-Reply-To: <51674C30.5060309@jp.fujitsu.com>
References: <1365719185-4799-1-git-send-email-toshi.kani@hp.com>
	 <51674C30.5060309@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-12 at 08:50 +0900, Yasuaki Ishimatsu wrote:
> 2013/04/12 7:26, Toshi Kani wrote:
> > Changed the config option of release_mem_region_adjustable() from
> > CONFIG_MEMORY_HOTPLUG to CONFIG_MEMORY_HOTREMOVE since this function
> > is only used for memory hot-delete.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> 
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks Yasuaki!
-Toshi




