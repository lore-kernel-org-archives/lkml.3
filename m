Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaJAScB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:32:01 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49347 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaJASb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:31:59 -0400
Message-ID: <542C489A.6020207@gmail.com>
Date: Wed, 01 Oct 2014 20:31:54 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?windows-1252?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Subject: Re: linux-next: manual merge of the net-next tree with the berlin
 tree
References: <20141001112212.44f53d35@canb.auug.org.au>
In-Reply-To: <20141001112212.44f53d35@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.10.2014 03:22, Stephen Rothwell wrote:
> Today's linux-next merge of the net-next tree got a conflict in
> arch/arm/boot/dts/berlin2q-marvell-dmp.dts between commit 461316fca705
> ("ARM: berlin: enable the eSATA interface on the BG2Q DMP") from the
> berlin tree and commit 75215193b975 ("ARM: dts: berlin: enable the
> Ethernet port on the BG2Q DMP") from the net-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me,

Thanks Stephen!

Sebastian
