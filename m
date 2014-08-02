Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbaHBK5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 06:57:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbaHBK5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 06:57:07 -0400
Message-ID: <53DCC3CF.4000003@redhat.com>
Date: Sat, 02 Aug 2014 12:56:15 +0200
From: Nikolay Aleksandrov <nikolay@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Graf <tgraf@suug.ch>, davem@davemloft.net, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, kaber@trash.net, paulmck@linux.vnet.ibm.com,
        josh@joshtriplett.org, challa@noironetworks.com, walpole@cs.pdx.edu,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] nftables: Convert nft_hash to use generic
 rhashtable
References: <cover.1406971567.git.tgraf@suug.ch> <583cb5fc8f1bc2f47d338dfba06f514e7b89a548.1406971567.git.tgraf@suug.ch>
In-Reply-To: <583cb5fc8f1bc2f47d338dfba06f514e7b89a548.1406971567.git.tgraf@suug.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2014 11:47 AM, Thomas Graf wrote:
> The sizing of the hash table and the practice of requiring a lookup
> to retrieve the pprev to be stored in the element cookie before the
> deletion of an entry is left intact.
> 
> Signed-off-by: Thomas Graf <tgraf@suug.ch>
> Acked-by: Patrick McHardy <kaber@trash.net>
> ---
>  net/netfilter/nft_hash.c | 291 +++++++++--------------------------------------
>  1 file changed, 55 insertions(+), 236 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <nikolay@redhat.com>

