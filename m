Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab3KEL0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:26:14 -0500
Received: from smtp.citrix.com ([66.165.176.89]:17452 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab3KEL0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:26:13 -0500
X-IronPort-AV: E=Sophos;i="4.93,639,1378857600"; 
   d="scan'208";a="70657015"
Message-ID: <5278D5D3.1020605@citrix.com>
Date: Tue, 5 Nov 2013 12:26:11 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>, Matt Wilson <msw@amazon.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] grant-table: don't set m2p override if kmap_ops is not
 set
References: <1383650649-13971-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1383650649-13971-1-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/13 12:24, Roger Pau Monne wrote:
> IMHO there's no reason to set a m2p override if the mapping is done in
> kernel space, so only set the m2p override when kmap_ops is set.
> 
> When kmap_ops is not set, just set the correct p2m translation, this
> avoids touching the m2p lock, reducing contention around it.
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Reported-by: Matt Wilson <msw@amazon.com>
> Cc: Matt Wilson <msw@amazon.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: David Vrabel <david.vrabel@citrix.com>
> Cc: Boris Ostrovsky <david.vrabel@citrix.com>

Sorry Boris, I got your address wrong.

