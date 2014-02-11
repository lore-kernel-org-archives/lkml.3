Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaBKSWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:22:00 -0500
Received: from smtp.citrix.com ([66.165.176.89]:60677 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbaBKSV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:21:59 -0500
X-IronPort-AV: E=Sophos;i="4.95,826,1384300800"; 
   d="scan'208";a="101692246"
Message-ID: <52FA6A44.6050003@citrix.com>
Date: Tue, 11 Feb 2014 18:21:56 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
CC: Sander Eikelenboom <linux@eikelenboom.it>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>, <mrushton@amazon.com>,
        <msw@amazon.com>, <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [GIT PULL] (xen) stable/for-jens-3.14 : NFO: trying
 to register non-static key. the code is fine but needs lockdep annotation.
References: <20140210184412.GA18198@phenom.dumpdata.com>	<20140210195402.GA3924@kernel.dk>	<771950784.20140211165215@eikelenboom.it>	<20140211155650.GA23026@phenom.dumpdata.com>	<1542261541.20140211170750@eikelenboom.it> <52FA6072.40908@citrix.com> <52FA6352.1010403@citrix.com> <52FA68AE.6070608@citrix.com>
In-Reply-To: <52FA68AE.6070608@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/14 18:15, Roger Pau Monné wrote:
> On 11/02/14 18:52, David Vrabel wrote:
>> 
> That would mean that unmap_purged_grants would no longer be static and 
> I should also add a prototype for it in blkback/common.h, which is kind 
> of ugly IMHO.

But less ugly than initializing work with a NULL function, IMO.

> commit 980e72e45454b64ccb7f23b6794a769384e51038
> Author: Roger Pau Monne <roger.pau@citrix.com>
> Date:   Tue Feb 11 19:04:06 2014 +0100
> 
>     xen-blkback: init persistent_purge_work work_struct
>     
>     Initialize persistent_purge_work work_struct on xen_blkif_alloc (and
>     remove the previous initialization done in purge_persistent_gnt). This
>     prevents flush_work from complaining even if purge_persistent_gnt has
>     not been used.
>     
>     Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Thanks.

David
