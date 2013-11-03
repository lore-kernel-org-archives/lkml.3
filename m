Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3KCHyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 02:54:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:24998 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab3KCHyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 02:54:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="316277517"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
CC: "Usyskin, Alexander" <alexander.usyskin@intel.com>,
        Nicol? Costanza <abitrules@yahoo.it>,
        Alex Burmashev <alex.burmashev@rosalab.ru>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: mei: cancel stall timers in mei_reset
Thread-Topic: mei: cancel stall timers in mei_reset
Thread-Index: AQHO1v25eHT6rrwZAkeTBc+srO32QJoTJVWQ
Date: Sun, 3 Nov 2013 07:53:59 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF00BC7@HASMSX106.ger.corp.intel.com>
References: <52739E2F.9030605@rosalab.ru>
In-Reply-To: <52739E2F.9030605@rosalab.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Eugene Shatokhin [mailto:eugene.shatokhin@rosalab.ru]
> Sent: Friday, November 01, 2013 14:27
> To: Winkler, Tomas
> Cc: Usyskin, Alexander; Nicolò Costanza; Alex Burmashev; LKML
> Subject: Re: mei: cancel stall timers in mei_reset
> 
> Hi,
> 
> In case my previous mail went to /dev/null, it is all about the flood of
> error messages in the system log, like these:
> 
> mei_me 0000:00:16.0: reset: wrong host start response
> mei_me 0000:00:16.0: unexpected reset: dev_state = INIT_CLIENTS
> mei_me 0000:00:16.0: reset: unexpected enumeration response hbm.
> mei_me 0000:00:16.0: unexpected reset: dev_state = INIT_CLIENTS
>

I would appreciate the full log and your .config 
Thanks
Tomas

 

