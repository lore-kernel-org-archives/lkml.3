Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaBSJsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:48:32 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:19797 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaBSJs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:48:27 -0500
X-IronPort-AV: E=Sophos;i="4.97,504,1389744000"; 
   d="scan'208";a="102120835"
Message-ID: <1392803304.23084.95.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [RFC v2 0/4] net: bridge / ip optimizations for
 virtual net backends
From: Ian Campbell <Ian.Campbell@citrix.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Date: Wed, 19 Feb 2014 09:48:24 +0000
In-Reply-To: <CAB=NE6VxNByeWGk6_Ow7WgxA3HCwGBjrjL9MNVRGsEfFyeKTdw@mail.gmail.com>
References: <1392433180-16052-1-git-send-email-mcgrof@do-not-panic.com>
	 <5301E411.5060908@citrix.com>
	 <CAB=NE6VxNByeWGk6_Ow7WgxA3HCwGBjrjL9MNVRGsEfFyeKTdw@mail.gmail.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 11:43 -0800, Luis R. Rodriguez wrote:
> 
> New motivation: removing IPv4 and IPv6 from the backend interfaces can
> save up a lot of boiler plate run time code, triggers from ever taking
> place, and simplifying the backend interaces. If there is no use for
> IPv4 and IPv6 interfaces why do we have them? Note: I have yet to test
> the NAT case.

I think you need to do that test that before you can unequivocally state
that there is no use for IPv4/6 interfaces here.

Ian.

