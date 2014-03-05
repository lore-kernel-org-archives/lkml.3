Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbaCEPjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:39:31 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:59951 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbaCEPj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 10:39:28 -0500
Message-ID: <531744E9.4000903@mellanox.com>
Date: Wed, 5 Mar 2014 17:38:17 +0200
From: Or Gerlitz <ogerlitz@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Hefty Sean <sean.hefty@intel.com>, linux-rdma <linux-rdma@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        target-devel <target-devel@vger.kernel.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: linux rdma 3.14 merge plans
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com> <1389820541.5567.543.camel@haakon3.risingtidesystems.com> <CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com> <1389906852.5567.668.camel@haakon3.risingtidesystems.com> <CAG4TOxPeYQ=e5LdJft1Hkx8donUQjJaKDEAv3iRLGxPYJQ_b9w@mail.gmail.com> <1390102949.5567.749.camel@haakon3.risingtidesystems.com> <52DBB4F1.4020400@mellanox.com> <CAJZOPZJFbcTh2zO8mos0M+gv0LW-Gmh877Vxe4tLvfPX19oqTw@mail.gmail.com> <CAJZOPZLuz-Z59agBd0Q9J2=sSG-F+Y8MrJkoGbtiF5M+CnKU1g@mail.gmail.com> <CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com> <1390375658.5567.917.camel@haakon3.risingtidesystems.com> <1391731323.14985.56.camel@haakon3.risingtidesystems.com> <CAG4TOxNpnMMR-vfAVa+m6f-z82msxygADUkJ7mmrKtzHCOqdhA@mail.gmail.com> <1394013249.19539.17.camel@haakon3.risingtidesystems.com> <CAG4TOxNRkAUH5Jsd67--ydWtUJqE1=pnVSuorgn4vNQiuYx1wg@mail.gmail.com>
In-Reply-To: <CAG4TOxNRkAUH5Jsd67--ydWtUJqE1=pnVSuorgn4vNQiuYx1wg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.222.66.109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2014 17:18, Roland Dreier wrote:
> On Wed, Mar 5, 2014 at 1:54 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org>  wrote:
>> >That all said, do you have an objection wrt taking this bits through
>> >target-pending..?  Given the dependencies involved, that would seem the
>> >most logical path to take.
> Perhaps not surprisingly, I would prefer to get a chance to review a
> major change to the core RDMA midlayer rather than having you merge it
> through your tree.  So yes I do object.  Please give me a chance to
> review and merge it.  I am working on that this week.

Hi Roland, we're very happy to hear that!!

As you know, we are soon marking whole five months!! (patches posted Oct 
15th/2013) of sitting and waiting to your feedback, lost few upstream 
releases on the way. Let's get this into the works.

Or.

Or.
