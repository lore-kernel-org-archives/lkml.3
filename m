Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3ICXCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 19:02:54 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:54307 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab3ICXCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 19:02:53 -0400
Date: Tue, 3 Sep 2013 19:02:40 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: larmbr <nasa4836@gmail.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, riel@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: make global_reclaim() inline
Message-ID: <20130903230240.GD1412@cmpxchg.org>
References: <20130822053956.GA10795@larmbr-lcx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822053956.GA10795@larmbr-lcx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 01:39:56PM +0800, larmbr wrote:
> Though Gcc is likely to inline them, we should better
> explictly do it manually, and also, this serve to document 
> this fact.

Why?
