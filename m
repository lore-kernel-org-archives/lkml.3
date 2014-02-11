Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbaBKUWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:22:05 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:42997 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbaBKUWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:22:01 -0500
Date: Tue, 11 Feb 2014 21:21:57 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1009282985.20140211212157@eikelenboom.it>
To: David Vrabel <david.vrabel@citrix.com>
CC: =?iso-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>, <mrushton@amazon.com>,
        <msw@amazon.com>, <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [GIT PULL] (xen) stable/for-jens-3.14 : NFO: trying to register non-static key. the code is fine but needs lockdep annotation.
In-Reply-To: <52FA6A44.6050003@citrix.com>
References: <20140210184412.GA18198@phenom.dumpdata.com> <20140210195402.GA3924@kernel.dk> <771950784.20140211165215@eikelenboom.it> <20140211155650.GA23026@phenom.dumpdata.com> <1542261541.20140211170750@eikelenboom.it> <52FA6072.40908@citrix.com> <52FA6352.1010403@citrix.com> <52FA68AE.6070608@citrix.com> <52FA6A44.6050003@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Tuesday, February 11, 2014, 7:21:56 PM, you wrote:

> On 11/02/14 18:15, Roger Pau Monné wrote:
>> On 11/02/14 18:52, David Vrabel wrote:
>>> 
>> That would mean that unmap_purged_grants would no longer be static and 
>> I should also add a prototype for it in blkback/common.h, which is kind 
>> of ugly IMHO.

> But less ugly than initializing work with a NULL function, IMO.

>> commit 980e72e45454b64ccb7f23b6794a769384e51038
>> Author: Roger Pau Monne <roger.pau@citrix.com>
>> Date:   Tue Feb 11 19:04:06 2014 +0100
>> 
>>     xen-blkback: init persistent_purge_work work_struct
>>     
>>     Initialize persistent_purge_work work_struct on xen_blkif_alloc (and
>>     remove the previous initialization done in purge_persistent_gnt). This
>>     prevents flush_work from complaining even if purge_persistent_gnt has
>>     not been used.
>>     
>>     Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>

> Reviewed-by: David Vrabel <david.vrabel@citrix.com>

And a Tested-by: Sander Eikelenboom <linux@eikelenboom.it>

Thanks !

> Thanks.

> David


