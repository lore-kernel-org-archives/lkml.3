Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaBMC2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 21:28:45 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:36360 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaBMC2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 21:28:44 -0500
Date: Wed, 12 Feb 2014 18:28:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daeseok Youn <daeseok.youn@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, toshi.kani@hp.com,
        isimatu.yasuaki@jp.fujitsu.com, gong.chen@linux.intel.com,
        haokexin@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/resource.c: fix sparse non static symbol
 warning
In-Reply-To: <2767883.6dX08SOjIi@daeseok-laptop.cloud.net>
Message-ID: <alpine.DEB.2.02.1402121828020.28897@chino.kir.corp.google.com>
References: <2767883.6dX08SOjIi@daeseok-laptop.cloud.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014, Daeseok Youn wrote:

> From f8e0752ac80e56bcbfe197a5820692d199822b52 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Thu, 13 Feb 2014 10:11:39 +0900
> Subject: [PATCH] kernel/resource.c: fix sparse non static symbol warning
> 
> kernel/resource.c:518:5: warning:
>  symbol 'reallocate_resource' was not declared. Should it be static?
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

Changelog would be better if it said it's only referenced in file scope so 
it can be marked static.

Acked-by: David Rientjes <rientjes@google.com>
