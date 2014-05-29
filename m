Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbaE2Thp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:37:45 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:63724 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465AbaE2Thl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:37:41 -0400
Date: Thu, 29 May 2014 12:37:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] CMA: correct unlock target
In-Reply-To: <1401344958-3790-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.02.1405291237280.28588@chino.kir.corp.google.com>
References: <1401344958-3790-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014, Joonsoo Kim wrote:

> 'cma: Remove potential deadlock situation' introduces per cma area mutex
> for bitmap management. It is good, but there is one mistake. When we
> can't find appropriate area in bitmap, we release cma_mutex global lock
> rather than cma->lock and this is a bug. So fix it.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: David Rientjes <rientjes@google.com>
