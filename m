Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab3EBB03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 21:26:29 -0400
Received: from intranet.asianux.com ([58.214.24.6]:48409 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab3EBB01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 21:26:27 -0400
X-Spam-Score: -100.8
Message-ID: <5181C093.3010301@asianux.com>
Date: Thu, 02 May 2013 09:25:39 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Ott <alan@signal11.us>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
References: <20130430122423.ab57c82604f13f6773ef4aeb@canb.auug.org.au>
In-Reply-To: <20130430122423.ab57c82604f13f6773ef4aeb@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月30日 10:24, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in
> net/mac802154/mac802154.h between commit 2c1bbbffa0b6 ("net: mac802154:
> comparision issue of type cast, finding by EXTRA_CFLAGS=-W") from the net
> tree and commit 7dd43d356e73 ("mac802154: Do not try to resend failed
> packets") from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks

-- 
Chen Gang

Asianux Corporation
