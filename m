Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaEZKwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:52:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbaEZKwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:52:43 -0400
Date: Mon, 26 May 2014 12:52:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Roland Dreier <roland@kernel.org>
cc: Or Gerlitz <or.gerlitz@gmail.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Amir Vadai <amirv@mellanox.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>, Mel Gorman <mgorman@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH v1 for-next 0/3] IB: Use GFP_NOIO calls in IPoIB connected
 mode TX path
In-Reply-To: <CAL1RGDUoEFF=fR-e-fc1v0yHp8sxaidBnO_2iiAFThgZNvCcfQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1405261251520.12047@pobox.suse.cz>
References: <1399810512-30774-1-git-send-email-ogerlitz@mellanox.com> <alpine.LNX.2.00.1405131338030.16459@pobox.suse.cz> <CAJZOPZJVxF6A-3s16feqoWCb5gOLTjyUmB3F+st1+1QWp+bJnQ@mail.gmail.com>
 <CAL1RGDUoEFF=fR-e-fc1v0yHp8sxaidBnO_2iiAFThgZNvCcfQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014, Roland Dreier wrote:

> > Roland, we're soon on -rc6 and there's no reason for this to miss
> > 3.16, could you please comment whether you want it to go through your
> > tree or net-next?
> 
> I will pick it up.

Thanks Roland.

Sorry for being a bit persistent, but another week has passed, -rc7 is out 
and I still don't see it in your tree. Could you please clarify what is 
the destiny of this patchset?

Thanks,

-- 
Jiri Kosina
SUSE Labs
