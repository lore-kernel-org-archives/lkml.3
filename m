Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaCJJAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:00:43 -0400
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:44246 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaCJJAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:00:40 -0400
From: Devesh Sharma <Devesh.Sharma@Emulex.Com>
To: Roland Dreier <roland@kernel.org>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Or Gerlitz <or.gerlitz@gmail.com>, Hefty Sean <sean.hefty@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        target-devel <target-devel@vger.kernel.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: linux rdma 3.14 merge plans
Thread-Topic: linux rdma 3.14 merge plans
Thread-Index: AQHPEv/nkBEzeM5EPE2XzLOY5CZpJ5qLjISAgABkjICAAH/ogIABvegAgAIZf4CAAC2ogIAAcO8AgBioz4CAAACmAIApgWaAgABavACAAD7KAIABtJoggAF38QCAA1mZIA==
Date: Mon, 10 Mar 2014 09:00:38 +0000
Message-ID: <EE7902D3F51F404C82415C4803930ACD3FDDE3DE@CMEXMB1.ad.emulex.com>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com>
 <CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA@mail.gmail.com>
 <52CD1C68.4050406@mellanox.com>
 <1389645171.5567.459.camel@haakon3.risingtidesystems.com>
 <1389820541.5567.543.camel@haakon3.risingtidesystems.com>
 <CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com>
 <1389906852.5567.668.camel@haakon3.risingtidesystems.com>
 <CAG4TOxPeYQ=e5LdJft1Hkx8donUQjJaKDEAv3iRLGxPYJQ_b9w@mail.gmail.com>
 <1390102949.5567.749.camel@haakon3.risingtidesystems.com>
 <52DBB4F1.4020400@mellanox.com>
 <CAJZOPZJFbcTh2zO8mos0M+gv0LW-Gmh877Vxe4tLvfPX19oqTw@mail.gmail.com>
 <CAJZOPZLuz-Z59agBd0Q9J2=sSG-F+Y8MrJkoGbtiF5M+CnKU1g@mail.gmail.com>
 <CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com>
 <1390375658.5567.917.camel@haakon3.risingtidesystems.com>
 <1391731323.14985.56.camel@haakon3.risingtidesystems.com>
 <CAG4TOxNpnMMR-vfAVa+m6f-z82msxygADUkJ7mmrKtzHCOqdhA@mail.gmail.com>
 <1394013249.19539.17.camel@haakon3.risingtidesystems.com>
 <CAG4TOxNRkAUH5Jsd67--ydWtUJqE1=pnVSuorgn4vNQiuYx1wg@mail.gmail.com>
 <1394046218.20601.12.camel@haakon3.risingtidesystems.com>
 <EE7902D3F51F404C82415C4803930ACD3FDDD50E@CMEXMB1.ad.emulex.com>
 <CAL1RGDXRCZafDcFsbiG823VQ7_AVZeZqxY8JEaj=oCYRteAw_A@mail.gmail.com>
In-Reply-To: <CAL1RGDXRCZafDcFsbiG823VQ7_AVZeZqxY8JEaj=oCYRteAw_A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.226.193.57]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Roland,
My response is inline below.

-Regards
 Devesh
-----Original Message-----
From: roland@purestorage.com [mailto:roland@purestorage.com] On Behalf Of Roland Dreier
Sent: Saturday, March 08, 2014 1:02 AM
To: Devesh Sharma
Cc: Nicholas A. Bellinger; Or Gerlitz; Hefty Sean; linux-rdma; Martin K. Petersen; target-devel; Sagi Grimberg; linux-kernel
Subject: Re: linux rdma 3.14 merge plans

Sure, no problem.

Do you have a git tree with the latest versions of all the changes you want for 3.15 in a branch?  That would be helpful as I catch up on applying things, so that I don't miss anything.
[DS]: Yes, I do have a cloned copy of your git tree migrated to for-next branch, with all the patches we have submitted to linux-rdma (patch series: [PATCH for-next 00/17] ocrdma driver code sync-up). However, it is on my local server.
In case of urgency (and if OFED EWG permits me) I can set it up on benay dot openfabrics dot org, for now and give a link to pull.

If you don't have one, taking a little time to set one up on github or wherever would be nice.  You can base your set of changes on Linus's latest tree.
[DS]: Currently we do not have such tree. I will have to discuss within my organization on how to go about this request. 

Thanks!
  Roland

On Thu, Mar 6, 2014 at 9:07 PM, Devesh Sharma <Devesh.Sharma@emulex.com> wrote:
> Hi Roland,
>
> Is it okay to send next series of patches even if previous series is not accepted yet in your tree? Off-course I will cut patches on top of previous series of patches.
>
> -Regards
>  Devesh
>
> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org 
> [mailto:linux-rdma-owner@vger.kernel.org] On Behalf Of Nicholas A. 
> Bellinger
> Sent: Thursday, March 06, 2014 12:34 AM
> To: Roland Dreier
> Cc: Or Gerlitz; Hefty Sean; linux-rdma; Martin K. Petersen; 
> target-devel; Sagi Grimberg; linux-kernel
> Subject: Re: linux rdma 3.14 merge plans
>
> On Wed, 2014-03-05 at 07:18 -0800, Roland Dreier wrote:
>> On Wed, Mar 5, 2014 at 1:54 AM, Nicholas A. Bellinger 
>> <nab@linux-iscsi.org> wrote:
>> > That all said, do you have an objection wrt taking this bits 
>> > through target-pending..?  Given the dependencies involved, that 
>> > would seem the most logical path to take.
>>
>> Perhaps not surprisingly, I would prefer to get a chance to review a 
>> major change to the core RDMA midlayer rather than having you merge 
>> it through your tree.  So yes I do object.  Please give me a chance 
>> to review and merge it.  I am working on that this week.
>>
>
> Great.  We'll be looking for a response by the end of the week.
>
> Otherwise if you end up not having time, we'd still like to move forward for v3.15 given the amount of review the series has already gotten on the list.
>
> Thank you,
>
> --nab
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
