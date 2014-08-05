Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaHENpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:45:38 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:36899 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaHENpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:45:36 -0400
X-IronPort-AV: E=Sophos;i="5.01,804,1400025600"; 
   d="scan'208";a="159509311"
Message-ID: <53E0DFFE.9090202@citrix.com>
Date: Tue, 5 Aug 2014 14:45:34 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Frediano Ziglio <frediano.ziglio@citrix.com>
CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xenproject.org>,
        <linux-api@vger.kernel.org>
Subject: Re: [PATCH 1/2] xen: Implement ioctl to restrict privcmd to a specific
 domain
References: <201407311317.s6VDHJV9013633@aserp1020.oracle.com> <20140804202633.GC6380@laptop.dumpdata.com> <1407229819.26842.4.camel@hamster.uk.xensource.com> <20140805134220.GD13057@laptop.dumpdata.com>
In-Reply-To: <20140805134220.GD13057@laptop.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/14 14:42, Konrad Rzeszutek Wilk wrote:
> 
>  - Some of these hypercalls don't have an ABI so we can't depend
>    on them being stable. How do you want to handle that?

We are not going any further with this series because of this.

David
