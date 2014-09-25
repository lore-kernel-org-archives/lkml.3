Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaIYPmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:42:43 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:33829 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbaIYPml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:42:41 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Thu, 25 Sep 2014 11:42:39 -0400
To: linux-kernel@vger.kernel.org
Cc: Len Sorensen <lsorense@csclub.uwaterloo.ca>,
        Mugunthan V N <mugunthanvnm@ti.com>
Subject: Re: cpsw without dual_emac drops multicast in promisc mode
Message-ID: <20140925154239.GC13319@csclub.uwaterloo.ca>
References: <20140925151906.GB13319@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925151906.GB13319@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 11:19:06AM -0400, Lennart Sorensen wrote:
> It seems that running tcpdump (and hence enabling promisc mode), causes
> all multicast packets to dropped with the cpsw driver.  We are not using
> the dual_emac feature, we are just using one port.  This is on the DRA7XX.
> 
> I see that in dual_emac mode, it is set to ALE_BYPASS (no idea if this
> works, I haven't tried dual_emac mode).  In non dual_emac mode it uses
> ALE_P0_UNI_FLOOD after flushing the multicast entries.  Maybe that's
> not good enough.

I forgot to CC the appropriate people.

-- 
Len Sorensen
