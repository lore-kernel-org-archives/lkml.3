Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763453Ab3IEHdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 03:33:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763402Ab3IEHdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 03:33:22 -0400
Message-ID: <522833B6.2040804@redhat.com>
Date: Thu, 05 Sep 2013 09:33:10 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the net-next tree with Linus' tree
References: <20130905151933.10e0558611271fdd2133a790@canb.auug.org.au>
In-Reply-To: <20130905151933.10e0558611271fdd2133a790@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 07:19 AM, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in
> net/bridge/br_multicast.c between commit 2d98c29b6fb3 ("net: bridge:
> convert MLDv2 Query MRC into msecs_to_jiffies for max_delay") from Linus'
> tree and commit e3f5b17047de ("net: ipv6: mld: get rid of MLDV2_MRC and
> simplify calculation") from the net-next tree.
>
> I just used the net-next tree version and can carry the fix as necessary
> (no action is required).

Sounds good thanks Stephen!
