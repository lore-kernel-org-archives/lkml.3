Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaKYLYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:24:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbaKYLYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:24:11 -0500
Message-ID: <547466C8.1000203@redhat.com>
Date: Tue, 25 Nov 2014 09:23:52 -0200
From: Marcelo Ricardo Leitner <mleitner@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: linux-next: manual merge of the net-next tree with the vfs tree
References: <20141125134246.2761ada5@canb.auug.org.au>
In-Reply-To: <20141125134246.2761ada5@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-11-2014 00:42, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in
> net/netfilter/nf_log.c between commit e71456ae9871 ("netfilter: Remove
> checks of seq_printf() return values") from the vfs tree and commit
> 0c26ed1c07f1 ("netfilter: nf_log: Introduce nft_log_dereference()
> macro") from the net-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>

Looks good to me, thanks Stephen.

Marcelo
