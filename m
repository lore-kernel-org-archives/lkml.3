Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3C0Tix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:38:53 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:45762 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3C0Tiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:38:52 -0400
Date: Wed, 27 Mar 2013 12:38:47 -0700
From: Tejun Heo <tj@kernel.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] idr: add idr_alloc_cyclic and convert existing
 cyclic users
Message-ID: <20130327193847.GF7395@htj.dyndns.org>
References: <1364412578-7462-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364412578-7462-1-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 03:29:32PM -0400, Jeff Layton wrote:
> (Andrew, I think this is probably best routed via -mm since it touches
> several different places)

Yeap, I think it'd be best to route these through -mm.

Please feel free to add Reviewed-by: Tejun Heo <tj@kernel.org> for the
whole series.

Thanks!

-- 
tejun
