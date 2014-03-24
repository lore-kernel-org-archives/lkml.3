Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaCXJ0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 05:26:51 -0400
Received: from smtp.citrix.com ([66.165.176.89]:29030 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaCXJ0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 05:26:50 -0400
X-IronPort-AV: E=Sophos;i="4.97,719,1389744000"; 
   d="scan'208";a="114239594"
Message-ID: <1395653207.19365.1.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH net-next] Revert "xen-netback: Aggregate TX unmap
 operations"
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <paul.durrant@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Date: Mon, 24 Mar 2014 09:26:47 +0000
In-Reply-To: <1395422584-16213-1-git-send-email-zoltan.kiss@citrix.com>
References: <1395422584-16213-1-git-send-email-zoltan.kiss@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-21 at 17:23 +0000, Zoltan Kiss wrote:
> This reverts commit e9275f5e2df1b2098a8cc405d87b88b9affd73e6. This commit is the
> last in the netback grant mapping series, and it tries to do more aggressive
> aggreagtion of unmap operations. However practical use showed almost no
> positive effect, whilst with certain frontends it causes significant performance
> regression.

That's a shame -- do you have any insight into why?

> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>


