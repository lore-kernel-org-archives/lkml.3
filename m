Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaFGWEt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 18:04:49 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:39898 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaFGWEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 18:04:48 -0400
Date: Sat, 7 Jun 2014 15:04:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: Re: [PATCH 1/1] fs/proc/kcore.c: use PAGE_ALIGN instead of
 ALIGN(PAGE_SIZE)
In-Reply-To: <1402149643-31534-1-git-send-email-fabf@skynet.be>
Message-ID: <alpine.DEB.2.02.1406071504310.24927@chino.kir.corp.google.com>
References: <1402149643-31534-1-git-send-email-fabf@skynet.be>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jun 2014, Fabian Frederick wrote:

> use mm.h definition
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Xishi Qiu <qiuxishi@huawei.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: David Rientjes <rientjes@google.com>
