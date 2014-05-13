Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaEMEFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 00:05:50 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:45274 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaEMEFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 00:05:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140513135322.3dfadb7c@canb.auug.org.au>
References: <20140513135322.3dfadb7c@canb.auug.org.au>
Date: Mon, 12 May 2014 21:05:48 -0700
Message-ID: <CAM_iQpWcH7TeBJ-NfdAvwuFqhe9U0ir=UO3f-P=E+znm54_Hag@mail.gmail.com>
Subject: Re: linux-next: manual merge of the net-next tree with the ipsec tree
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 8:53 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in
> net/ipv6/xfrm6_output.c between commit 5596732fa8c1 ("xfrm: Fix crash
> with ipv6 IPsec tunnel and NAT") from the ipsec tree and commit
> 60ff746739bf ("net: rename local_df to ignore_df") from the net-next
> tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>

Looks good. Thanks!
