Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaEVCyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 22:54:11 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39323 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaEVCyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 22:54:09 -0400
Date: Wed, 21 May 2014 19:54:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Gioh Kim <gioh.kim@lge.com>
cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: [RFC] I found an errataum at drivers/base/dma-contiguous.c:294
In-Reply-To: <537D54D3.9060908@lge.com>
Message-ID: <alpine.DEB.2.02.1405211953490.13243@chino.kir.corp.google.com>
References: <537D54D3.9060908@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014, Gioh Kim wrote:

> This is not a big deal but I think get_dev_cma_area is errataum of dev_get_cma_area.
> 

Looks good, but you may want to read Documentation/SubmittingPatches when 
proposing patches.
