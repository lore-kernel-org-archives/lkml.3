Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3KVTXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:23:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54933 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab3KVTXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:23:00 -0500
Message-ID: <528FAF0E.6040802@infradead.org>
Date: Fri, 22 Nov 2013 11:22:54 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Adrian Pop <sultryweather@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>
Subject: Re: linux-next: Tree for Nov 21 (nouveau)
References: <20131121140411.092318822bbd82b7b47e0d53@canb.auug.org.au> <528E2BC3.4040007@infradead.org> <20131122113748.GB20300@shodan>
In-Reply-To: <20131122113748.GB20300@shodan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/13 03:37, Adrian Pop wrote:
> Hello!
> 
>> on x86_64:
>>
>> CONFIG_HWMON is not enabled.
>>
>> drivers/gpu/drm/nouveau/nouveau_hwmon.c: In function 'nouveau_hwmon_init':
>> drivers/gpu/drm/nouveau/nouveau_hwmon.c:633:2: error: 'hwmon' undeclared (first use in this function)
> 
> I've attached a patch that fixes the build for me when using this
> config.
> 

That works.  Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>


-- 
~Randy
