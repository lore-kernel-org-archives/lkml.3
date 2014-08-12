Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbaHLJSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:18:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbaHLJS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:18:28 -0400
Date: Tue, 12 Aug 2014 11:18:50 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: razya@il.ibm.com, kvm@vger.kernel.org, GLIKSON@il.ibm.com,
        ERANRA@il.ibm.com, YOSSIKU@il.ibm.com, JOELN@il.ibm.com,
        abel.gordon@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] vhost: Add polling mode
Message-ID: <20140812091850.GD6440@redhat.com>
References: <1407659404-razya@il.ibm.com>
 <20140810083035.0CF58380729@moren.haifa.ibm.com>
 <20140810194559.GA4344@redhat.com>
 <20140811.124621.576073630604147753.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811.124621.576073630604147753.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 12:46:21PM -0700, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Sun, 10 Aug 2014 21:45:59 +0200
> 
> > On Sun, Aug 10, 2014 at 11:30:35AM +0300, Razya Ladelsky wrote:
>  ...
> > And, did your tests actually produce 100% load on both host CPUs?
>  ...
> 
> Michael, please do not quote an entire patch just to ask a one line
> question.
> 
> I truly, truly, wish it was simpler in modern email clients to delete
> the unrelated quoted material because I bet when people do this they
> are simply being lazy.
> 
> Thank you.

Lazy - mea culpa, though I'm using mutt so it isn't even hard.

The question still stands: the test results are only valid
if CPU was at 100% in all configurations.
This is the reason I generally prefer it when people report
throughput divided by CPU (power would be good too but it still
isn't easy for people to get that number).

-- 
MST

