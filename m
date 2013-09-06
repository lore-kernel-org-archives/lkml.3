Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab3IFRPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:15:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47252 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3IFRPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:15:22 -0400
Message-ID: <522A0D87.7020201@infradead.org>
Date: Fri, 06 Sep 2013 10:14:47 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>
Subject: Re: linux-next: Tree for Aug 30 (nouveau)
References: <20130829200013.d9dde1eb64686a32c661b5d3@canb.auug.org.au> <5220F9A3.8030307@infradead.org>
In-Reply-To: <5220F9A3.8030307@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/13 12:59, Randy Dunlap wrote:
> On 08/29/13 03:00, Stephen Rothwell wrote:
>> Hi all,
>>
> 
> 
> on x86_64:
> 
> ERROR: "nouveau_switcheroo_optimus_dsm" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
> 
> 
> Full randconfig file is attached.
> 
> 

This build error still happens in linux-next of 20130906.

-- 
~Randy
