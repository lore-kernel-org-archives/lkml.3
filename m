Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaBJNXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:23:21 -0500
Received: from smtp.citrix.com ([66.165.176.89]:5184 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbaBJNXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:23:20 -0500
X-IronPort-AV: E=Sophos;i="4.95,817,1384300800"; 
   d="scan'208";a="101292359"
Message-ID: <52F8D2C5.6040507@citrix.com>
Date: Mon, 10 Feb 2014 13:23:17 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        <xen-devel@lists.xenproject.org>, Tony Luck <tony.luck@intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] ia64/xen: Remove Xen support for ia64 even
 more
References: <1391898943.27190.5.camel@x220>
In-Reply-To: <1391898943.27190.5.camel@x220>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/14 22:35, Paul Bolle wrote:
> Commit d52eefb47d4e ("ia64/xen: Remove Xen support for ia64") removed
> the Kconfig symbol XEN_XENCOMM. But it didn't remove the code depending
> on that symbol. Remove that code now.

Acked-by: David Vrabel <david.vrabel@citrix.com>

David
