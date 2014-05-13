Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbaEMLiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:38:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52803 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbaEMLio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:38:44 -0400
Date: Tue, 13 May 2014 13:38:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Or Gerlitz <ogerlitz@mellanox.com>
cc: roland@kernel.org, amirv@mellanox.com, linux-rdma@vger.kernel.org,
        saeedm@mellanox.com, Mel Gorman <mgorman@suse.de>,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 for-next 0/3] IB: Use GFP_NOIO calls in IPoIB connected
 mode TX path 
In-Reply-To: <1399810512-30774-1-git-send-email-ogerlitz@mellanox.com>
Message-ID: <alpine.LNX.2.00.1405131338030.16459@pobox.suse.cz>
References: <1399810512-30774-1-git-send-email-ogerlitz@mellanox.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2014, Or Gerlitz wrote:

> This series is a refactored form of the one posted by Jiri Kosina 
> to LKML and netdev according to the discussion that followed
> and the guidelines you provided here https://lkml.org/lkml/2014/3/5/250
> 
> Basically, the functionality changes introduced by this series fully 
> reside on the IB side of things, so I am only posting the actual patches 
> to linux-rdma with CC on the cover-letter to the lists that were on V0.

Thanks, I am fine with my Signoff on that.

Roland, is this going to be merged by you, or should this go to DaveM 
directly?

Thanks,

-- 
Jiri Kosina
SUSE Labs
