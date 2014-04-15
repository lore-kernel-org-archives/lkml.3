Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaDORyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:54:22 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:40373 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaDORyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:54:21 -0400
X-IronPort-AV: E=Sophos;i="4.97,865,1389744000"; 
   d="scan'208";a="120213057"
Message-ID: <534D7244.5000002@citrix.com>
Date: Tue, 15 Apr 2014 18:54:12 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Vincenzo Maffione <v.maffione@gmail.com>
CC: <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: net: xen-netfront: remove unused arrays
References: <1397583579-32162-1-git-send-email-v.maffione@gmail.com>
In-Reply-To: <1397583579-32162-1-git-send-email-v.maffione@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/14 18:39, Vincenzo Maffione wrote:
> This patch removes some unused arrays from the netfront
> private data structure.
> Also removes an unused address variable.
> 
> Signed-off-by: Vincenzo Maffione <v.maffione@gmail.com>

Huh. I wonder what they were for.

Acked-by: David Vrabel <david.vrabel@citrix.com>

For net related patches please say whether they're for the net (current
RCs) or net-next branch.  e.g.,

[PATCH net-next] xen-netfront: removed unused arrays.

Thanks.

David
