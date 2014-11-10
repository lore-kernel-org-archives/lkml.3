Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaKJQmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:42:50 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:30622 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbaKJQmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:42:47 -0500
X-IronPort-AV: E=Sophos;i="5.07,353,1413244800"; 
   d="scan'208";a="191251201"
Message-ID: <5460EAF1.5020903@citrix.com>
Date: Mon, 10 Nov 2014 16:42:25 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Zoltan Kiss <zoltan.kiss@linaro.org>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] BUG in xennet_make_frags with paged skb data
References: <20141106214940.GD44162@ubuntu-hedt> <545CA27F.4070400@citrix.com>	<20141110143517.GA74005@ubuntu-hedt> <5460CEA5.3070201@citrix.com> <5460EA45.2080202@linaro.org>
In-Reply-To: <5460EA45.2080202@linaro.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/14 16:39, Zoltan Kiss wrote:
> 
> The BUG_ON suggested by Stefan would be still reasonable:
> 
> BUG_ON(((page-compound_head(page))*PAGE_SIZE)+offset+len >
> PAGE_SIZE<<compound_order(compound_head(page)));

Well, it wouldn't trigger but I don't think it is useful any more.

David
