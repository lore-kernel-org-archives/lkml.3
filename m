Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaBQRwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:52:51 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:52433 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaBQRwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:52:50 -0500
X-IronPort-AV: E=Sophos;i="4.95,862,1384300800"; 
   d="scan'208";a="101498693"
Message-ID: <53024C58.4010900@citrix.com>
Date: Mon, 17 Feb 2014 17:52:24 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, <netdev@vger.kernel.org>
CC: <kvm@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@suse.com>,
        <bridge@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [RFC v2 1/4] bridge: enable interfaces to opt out
 from becoming the root bridge
References: <1392433180-16052-1-git-send-email-mcgrof@do-not-panic.com> <1392433180-16052-2-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1392433180-16052-2-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/02/14 02:59, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> It doesn't make sense for some interfaces to become a root bridge
> at any point in time. One example is virtual backend interfaces
> which rely on other entities on the bridge for actual physical
> connectivity. They only provide virtual access.

It is possible that a guest bridge together to VIF, either from the same 
Dom0 bridge or from different ones. In that case using STP on VIFs sound 
sensible to me.

Zoli
