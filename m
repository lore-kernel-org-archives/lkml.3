Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab3C0Tf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:35:27 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:49972 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab3C0TfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:35:25 -0400
Date: Wed, 27 Mar 2013 12:35:09 -0700
From: Tejun Heo <tj@kernel.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Steve Wise <swise@opengridcomputing.com>,
        Tom Tucker <tom@opengridcomputing.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 2/6] amso1100: convert to using idr_alloc_cyclic
Message-ID: <20130327193509.GE7395@htj.dyndns.org>
References: <1364412578-7462-1-git-send-email-jlayton@redhat.com>
 <1364412578-7462-3-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364412578-7462-3-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 03:29:34PM -0400, Jeff Layton wrote:
> (Note: compile-tested only)
>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Steve Wise <swise@opengridcomputing.com>
> Cc: Tom Tucker <tom@opengridcomputing.com>
> Cc: linux-rdma@vger.kernel.org

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
