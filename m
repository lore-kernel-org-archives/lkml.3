Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaBJNiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:38:07 -0500
Received: from smtp.citrix.com ([66.165.176.89]:36278 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbaBJNiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:38:02 -0500
X-IronPort-AV: E=Sophos;i="4.95,818,1384300800"; 
   d="scan'208";a="101295376"
Message-ID: <52F8D637.30204@citrix.com>
Date: Mon, 10 Feb 2014 13:37:59 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: Paul Bolle <pebolle@tiscali.nl>, Tony Luck <tony.luck@intel.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH] ia64/xen: Remove Xen support for ia64 even
 more
References: <1391898943.27190.5.camel@x220> <52F8D2C5.6040507@citrix.com>
In-Reply-To: <52F8D2C5.6040507@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/14 13:23, David Vrabel wrote:
> On 08/02/14 22:35, Paul Bolle wrote:
>> Commit d52eefb47d4e ("ia64/xen: Remove Xen support for ia64") removed
>> the Kconfig symbol XEN_XENCOMM. But it didn't remove the code depending
>> on that symbol. Remove that code now.
> 
> Acked-by: David Vrabel <david.vrabel@citrix.com>

Forgot to say, since this only touches drivers/xen this is best merged
via the Xen tree.

Thanks

David
