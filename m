Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaBQK1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 05:27:40 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:35398 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaBQK1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:27:38 -0500
X-IronPort-AV: E=Sophos;i="4.95,859,1384300800"; 
   d="scan'208";a="101378133"
Message-ID: <5301E411.5060908@citrix.com>
Date: Mon, 17 Feb 2014 10:27:29 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: <netdev@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [Xen-devel] [RFC v2 0/4] net: bridge / ip optimizations for virtual
 net backends
References: <1392433180-16052-1-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1392433180-16052-1-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/02/14 02:59, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> This v2 series changes the approach from my original virtualization
> multicast patch series [0] by abandoning completely the multicast
> issues and instead generalizing an approach for virtualization
> backends. There are two things in common with virtualization
> backends:
> 
>   0) they should not become the root bridge
>   1) they don't need ipv4 / ipv6 interfaces

Why?  There's no real difference between a backend network device and a
physical device (from the point of view of the backend domain).  I do
not think these are intrinsic properties of backend devices.

I can see these being useful knobs for administrators (or management
toolstacks) to turn on, on a per-device basis.

David
