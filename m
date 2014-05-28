Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbaE1OND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:13:03 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:62365 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbaE1ONA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:13:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAG4TOxMsq+okTzDrgTetDeXnAgQ+iGCZLbjAZx1iBD0xDmce6g@mail.gmail.com>
References: <1399810512-30774-1-git-send-email-ogerlitz@mellanox.com>
	<alpine.LNX.2.00.1405131338030.16459@pobox.suse.cz>
	<CAJZOPZJVxF6A-3s16feqoWCb5gOLTjyUmB3F+st1+1QWp+bJnQ@mail.gmail.com>
	<CAL1RGDUoEFF=fR-e-fc1v0yHp8sxaidBnO_2iiAFThgZNvCcfQ@mail.gmail.com>
	<alpine.LNX.2.00.1405261251520.12047@pobox.suse.cz>
	<CAJZOPZ+OPc9VWqwyE_erZfQbQ0VV-0yr7NiCyJOH5LUM_xyx2g@mail.gmail.com>
	<CAG4TOxMsq+okTzDrgTetDeXnAgQ+iGCZLbjAZx1iBD0xDmce6g@mail.gmail.com>
Date: Wed, 28 May 2014 17:12:59 +0300
Message-ID: <CAJZOPZ+ThgPaRVLe=y_0r0qrKofMOv4DSpfFymmaAD1cgCyQwQ@mail.gmail.com>
Subject: Re: [PATCH v1 for-next 0/3] IB: Use GFP_NOIO calls in IPoIB connected
 mode TX path
From: Or Gerlitz <or.gerlitz@gmail.com>
To: Roland Dreier <roland.dreier@gmail.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>,
        Jiri Kosina <jkosina@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Amir Vadai <amirv@mellanox.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 5:05 PM, Roland Dreier <roland.dreier@gmail.com> wrote:
>
>
> > Roland, so M2 starts worrying, you have picked into your for-next
> > branch yesterday the other pending series, but not this one, so?
>
> Who is M2?

me too
