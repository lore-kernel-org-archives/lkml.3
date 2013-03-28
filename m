Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3C1Nxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 09:53:33 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37045 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab3C1Nxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:53:31 -0400
Date: Thu, 28 Mar 2013 09:53:08 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 6/6] sctp: convert sctp_assoc_set_id to use
 idr_alloc_cyclic
Message-ID: <20130328135308.GA14489@neilslaptop.think-freely.org>
References: <1364412578-7462-1-git-send-email-jlayton@redhat.com>
 <1364412578-7462-7-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364412578-7462-7-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 03:29:38PM -0400, Jeff Layton wrote:
> (Note: compile-tested only)
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Cc: Vlad Yasevich <vyasevich@gmail.com>
> Cc: Sridhar Samudrala <sri@us.ibm.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-sctp@vger.kernel.org
> Cc: netdev@vger.kernel.org
> ---
>  net/sctp/associola.c | 16 ++--------------
>  1 file changed, 2 insertions(+), 14 deletions(-)
> 
I don't see anything wrong with this patch per-se, but the idr_alloc_cyclic call
isn't integrated with net/net-next or Linus' tree yet.  If we don't gate this
patch on that integration, we'll break the build.
Neil

