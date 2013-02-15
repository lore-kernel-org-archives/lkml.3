Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab3BOUjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:39:21 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44453 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3BOUjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:39:20 -0500
Date: Fri, 15 Feb 2013 15:39:13 -0500 (EST)
Message-Id: <20130215.153913.1285091915738918107.davem@davemloft.net>
To: hannes@cmpxchg.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, npiggin@suse.de,
        stewart@flamingspork.com, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [patch 1/2] mm: fincore()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130215063450.GA24047@cmpxchg.org>
References: <20130211162701.GB13218@cmpxchg.org>
	<20130211141239.f4decf03.akpm@linux-foundation.org>
	<20130215063450.GA24047@cmpxchg.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Date: Fri, 15 Feb 2013 01:34:50 -0500

> +	nr_pages = DIV_ROUND_UP(len, PAGE_CACHE_SIZE);

A small nit, maybe use PAGE_CACHE_ALIGN() here.
