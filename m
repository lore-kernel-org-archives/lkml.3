Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbbAVB6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:58:17 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:38031 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbbAVB6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:58:05 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 22 Jan 2015 10:59:04 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, cl@linux.com, brouer@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH] mm/slub: use unchecked percpu access within preemptible
 sections
Message-ID: <20150122015904.GF21444@js1304-P5Q-DELUXE>
References: <1421814703-1869-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421814703-1869-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 11:31:43PM -0500, Sasha Levin wrote:
> Commit "mm/slub: optimize alloc/free fastpath by removing preemption on/off"
> has added access to percpu memory while the code is preemptible.
> 
> While those accesses are okay, this creates a huge amount of warnings from
> the code that checks for that.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Hello,

I already sent the patch to fix this issue and it is in mmotm, but,
not be released yet.

https://lkml.org/lkml/2015/1/19/17

Thanks.

