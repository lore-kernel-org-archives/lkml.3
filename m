Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab3IHBng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 21:43:36 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:57325 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3IHBnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 21:43:35 -0400
Date: Sat, 7 Sep 2013 18:43:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hugh Dickins <hughd@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] vmpressure: fix divide-by-0 in vmpressure_work_fn
In-Reply-To: <alpine.LNX.2.00.1309062254470.11420@eggly.anvils>
Message-ID: <alpine.DEB.2.02.1309071843230.8326@chino.kir.corp.google.com>
References: <alpine.LNX.2.00.1309062254470.11420@eggly.anvils>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Sep 2013, Hugh Dickins wrote:

> Hit divide-by-0 in vmpressure_work_fn(): checking vmpr->scanned before
> taking the lock is not enough, we must check scanned afterwards too.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org

Acked-by: David Rientjes <rientjes@google.com>
