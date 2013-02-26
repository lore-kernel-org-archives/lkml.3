Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759710Ab3BZH1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 02:27:25 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:33120 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758887Ab3BZH1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 02:27:23 -0500
Message-ID: <512C63CA.3050004@mellanox.com>
Date: Tue, 26 Feb 2013 09:27:06 +0200
From: Or Gerlitz <ogerlitz@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Roland Dreier <roland@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hadar Hen Zion <hadarh@mellanox.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Shani Michaeli <shanim@mellanox.com>,
        Haggai Eran <haggaie@mellanox.com>, Amir Vadai <amirv@mellanox.com>
Subject: Re: linux-next: manual merge of the infiniband tree with Linus' tree
References: <20130226114508.0f8d1101156f9f4a309579f6@canb.auug.org.au>
In-Reply-To: <20130226114508.0f8d1101156f9f4a309579f6@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.222.66.109]
X-TM-AS-Product-Ver: SMEX-10.0.0.4211-7.000.1014-19666.002
X-TM-AS-Result: No--4.546500-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/2013 02:45, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the infiniband tree got a conflict in
> drivers/net/ethernet/mellanox/mlx4/mlx4.h between commit 23537b732f5d
> ("net/mlx4_core: Use firmware driven flow steering hash mode") from
> Linus' tree and commit e448834e3545 ("mlx4_core: Enable memory windows in
> {INIT, QUERY}_HCA") from the infiniband tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>

thanks,

Acked-by: Or Gerlitz <ogerlitz@mellanox.com>
