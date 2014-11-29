Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaK2RYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 12:24:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbaK2RYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 12:24:14 -0500
Date: Sat, 29 Nov 2014 19:23:31 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org,
        pbonzini@redhat.com, thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Tom Herbert <therbert@google.com>, Ben Hutchings <ben@decadent.org.uk>,
        Masatake YAMATO <yamato@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, Xi Wang <xii@google.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v6 38/46] tun: drop most type defines
Message-ID: <20141129172331.GC22746@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
 <1417118789-18231-39-git-send-email-mst@redhat.com>
 <1417162188.5822.1@smtp.corp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417162188.5822.1@smtp.corp.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 08:17:48AM +0008, Jason Wang wrote:
> 
> 
> On Fri, Nov 28, 2014 at 4:11 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> >It's just as easy to use IFF_ flags directly,
> >there's no point in adding our own defines.
> >
> >Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >---
> > drivers/net/tun.c | 62
> >+++++++++++++++++++++++++------------------------------
> > 1 file changed, 28 insertions(+), 34 deletions(-)
> >
> >diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> 
> Patch looks fine, but I don't see the reason that why not squash patch 37
> into this.
> 
> [..]

squashing is always easy, I thought review is easier if at each step
identity to original code can be verified directly.
