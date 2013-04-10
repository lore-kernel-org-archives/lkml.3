Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab3DJFdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 01:33:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:7521 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab3DJFdR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 01:33:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,444,1363158000"; 
   d="scan'208";a="292744960"
From: "Jiang, Dave" <dave.jiang@intel.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
CC: Dan Williams <djbw@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] Add Intel Atom S1200 seris ioatdma support
Thread-Topic: [PATCH 00/10] Add Intel Atom S1200 seris ioatdma support
Thread-Index: AQHONPPDBMqB/k3bwky5zfIkIrEBk5jPFzaAgABFA4D//5OsIQ==
Date: Wed, 10 Apr 2013 05:33:16 +0000
Message-ID: <1B828A0C-A47D-4356-B629-07A95A52772D@intel.com>
References: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
 <20130409072801.GB31193@intel.com>
 <CAA9_cmftcvYN_g0Sj12tMa4T8LxbPdk6wDxwkbTrgQPUUfc0FA@mail.gmail.com>,<20130410050059.GI31193@intel.com>
In-Reply-To: <20130410050059.GI31193@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 9, 2013, at 10:30 PM, "Koul, Vinod" <vinod.koul@intel.com> wrote:

> On Tue, Apr 09, 2013 at 05:53:59PM -0700, Dan Williams wrote:
>> On Tue, Apr 9, 2013 at 12:28 AM, Vinod Koul <vinod.koul@intel.com> wrote:
>>> Are you okay with the series. Merge window is very close...
>>> 
>>> 
>> Hi Vinod, thanks for the ping.
>> 
>> Chatted with Dave patches 1-3 and 5-8, and 10 are reviewed/acked.  For
>> patch 4 and 9 we think we have a slightly cleaner way to organize the quirk
>> handling and an update will be coming.
> Dave,
> 
> I tried these, but they fail to apply on for-linus branch of my tree.
> Cna you pls rebase these 8 patches and resend.
> 
> --
> ~Vinod

Yes I will rebase and send them with the other two changed patches. It depends on the haswell patch. Could it be that?