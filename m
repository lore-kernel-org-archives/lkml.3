Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaCEJuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:50:39 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:60509 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbaCEJud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:50:33 -0500
Message-ID: <1394013249.19539.17.camel@haakon3.risingtidesystems.com>
Subject: Re: linux rdma 3.14 merge plans
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Roland Dreier <roland@kernel.org>
Cc: Or Gerlitz <or.gerlitz@gmail.com>, Hefty Sean <sean.hefty@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        target-devel <target-devel@vger.kernel.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 05 Mar 2014 01:54:09 -0800
In-Reply-To: <CAG4TOxNpnMMR-vfAVa+m6f-z82msxygADUkJ7mmrKtzHCOqdhA@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-06 at 16:04 -0800, Roland Dreier wrote:
> On Thu, Feb 6, 2014 at 4:02 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > Can you give us an estimate of when you'll have some time to give
> > feedback on the outstanding patches..?
> 
> I hope to get to it in the next few weeks.
> 
>  - R.

Hi Roland,

We'd very much like to move forward with the verbs + mlx5 + LIO target
PI related patches for v3.15 code.

Given the verbs + mlx5 changes have undergone ~5 months of review at
this point, I'd like to go ahead and get them in target-pending/for-next
ASAP to continue making forward progress towards a mainline merge.

I'm happy with the state of the iser-target related changes, and Sagi &
Co are making good progress on the iser-initiator related patches with
Mike.

That all said, do you have an objection wrt taking this bits through
target-pending..?  Given the dependencies involved, that would seem the
most logical path to take.

--nab 

