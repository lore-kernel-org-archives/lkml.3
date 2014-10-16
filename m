Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaJPHUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:20:38 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:52430 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870AbaJPHUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:20:37 -0400
Message-ID: <1413444034.2128.27.camel@x220>
Subject: Re: [patch 3/3] kernel: res_counter: remove the unused API
From: Paul Bolle <pebolle@tiscali.nl>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        Vladimir Davydov <vdavydov@parallels.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 16 Oct 2014 09:20:34 +0200
In-Reply-To: <1413251163-8517-4-git-send-email-hannes@cmpxchg.org>
References: <1413251163-8517-1-git-send-email-hannes@cmpxchg.org>
	 <1413251163-8517-4-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2014 07:20:34.0788 (UTC) FILETIME=[AD474A40:01CFE911]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 21:46 -0400, Johannes Weiner wrote:
> All memory accounting and limiting has been switched over to the
> lockless page counters.  Bye, res_counter!
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Vladimir Davydov <vdavydov@parallels.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>

This patch landed in today's linux-next (ie, next 20141016).

>  Documentation/cgroups/resource_counter.txt | 197 -------------------------
>  include/linux/res_counter.h                | 223 -----------------------------
>  init/Kconfig                               |   6 -
>  kernel/Makefile                            |   1 -
>  kernel/res_counter.c                       | 211 ---------------------------
>  5 files changed, 638 deletions(-)
>  delete mode 100644 Documentation/cgroups/resource_counter.txt
>  delete mode 100644 include/linux/res_counter.h
>  delete mode 100644 kernel/res_counter.c

There's a last reference to CONFIG_RESOURCE_COUNTERS in
Documentation/cgroups/memory.txt. That reference could be dropped too,
couldn't it?


Paul Bolle

