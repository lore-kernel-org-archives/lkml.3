Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3FLUQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:16:37 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38717 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3FLUQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:16:35 -0400
Date: Wed, 12 Jun 2013 13:16:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: Remove zone_type argument of build_zonelists_node
In-Reply-To: <51B86456.3060606@gmail.com>
Message-ID: <alpine.DEB.2.02.1306121316230.23348@chino.kir.corp.google.com>
References: <51B86456.3060606@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013, Zhang Yanfei wrote:

> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> 
> The callers of build_zonelists_node always pass MAX_NR_ZONES -1
> as the zone_type argument, so we can directly use the value
> in build_zonelists_node and remove zone_type argument.
> 
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
