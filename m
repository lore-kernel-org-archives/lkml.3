Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab3LITuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:50:21 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:51315 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab3LITuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:50:18 -0500
Date: Mon, 9 Dec 2013 11:50:13 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Xishi Qiu <qiuxishi@huawei.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: add show num_poisoned_pages when oom
In-Reply-To: <52A592DE.7010302@huawei.com>
Message-ID: <alpine.DEB.2.02.1312091149440.2321@chino.kir.corp.google.com>
References: <52A592DE.7010302@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013, Xishi Qiu wrote:

> Show num_poisoned_pages when oom, it is helpful to find the reason.
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>

Acked-by: David Rientjes <rientjes@google.com>

Although this patch says it's for oom conditions, it will be emitted 
anytime show_mem() is called which sounds good as well.
