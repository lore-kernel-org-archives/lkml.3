Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbbAWMAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 07:00:45 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:39150 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbbAWMAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 07:00:44 -0500
X-IronPort-AV: E=Sophos;i="5.09,453,1418083200"; 
   d="scan'208";a="220840378"
Message-ID: <54C237EA.8080303@citrix.com>
Date: Fri, 23 Jan 2015 12:00:42 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/tmem: mark xen_tmem_init() __init
References: <54C2163D0200007800058921@mail.emea.novell.com>
In-Reply-To: <54C2163D0200007800058921@mail.emea.novell.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/15 08:37, Jan Beulich wrote:
> As a module_init() function, this should have been this way from the
> beginning.

Applied to devel/for-linus-3.20, thanks.

David
