Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaBLA2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 19:28:05 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:65044 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbaBLA2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 19:28:03 -0500
Date: Tue, 11 Feb 2014 16:28:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jianguo Wu <wujianguo@huawei.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [question] how to figure out OOM reason? should dump slab/vmalloc
 info when OOM?
In-Reply-To: <52F9A1D8.7040301@huawei.com>
Message-ID: <alpine.DEB.2.02.1402111627400.29715@chino.kir.corp.google.com>
References: <52DCFC33.80008@huawei.com> <alpine.DEB.2.02.1401202130590.21729@chino.kir.corp.google.com> <52DE6AA0.1000801@huawei.com> <alpine.DEB.2.02.1401211236520.10355@chino.kir.corp.google.com> <52F9A1D8.7040301@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Jianguo Wu wrote:

> Thanks for your kindly explanation, do you have any specific plans on this?
> 

We're going to be discussing it at the LSF/mm conference at the end of 
March.
