Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3A3Iub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:50:31 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:37199 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3A3Iu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:50:29 -0500
Date: Wed, 30 Jan 2013 00:50:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tang Chen <tangchen@cn.fujitsu.com>
cc: akpm@linux-foundation.org, jiang.liu@huawei.com, wujianguo@huawei.com,
        hpa@zytor.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au, lliubbo@gmail.com,
        jaegeuk.hanse@gmail.com, tony.luck@intel.com, glommer@parallels.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH Bug fix] acpi, movablemem_map: node0 should always be
 unhotpluggable when using SRAT.
In-Reply-To: <1359532470-28874-1-git-send-email-tangchen@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1301300049100.19679@chino.kir.corp.google.com>
References: <1359532470-28874-1-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013, Tang Chen wrote:

> When using movablemem_map=acpi, always set node0 as unhotpluggable, otherwise
> if all the memory is hotpluggable, the kernel will fail to boot.
> 
> When using movablemem_map=nn[KMG]@ss[KMG], we don't stop users specifying
> node0 as hotpluggable, and ignore all the info in SRAT, so that this option
> can be used as a workaround of firmware bugs.
> 

Could you elaborate on the failure you're seeing?

I've booted the kernel many times without memory on a node 0.
