Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab3GIKTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 06:19:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab3GIKTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 06:19:50 -0400
Date: Tue, 9 Jul 2013 13:21:02 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, jasowang@redhat.com
Subject: Re: [PATCH v2 0/2] virtio_net: fix race in RX VQ processing
Message-ID: <20130709102102.GA14321@redhat.com>
References: <1373346713-442-1-git-send-email-mst@redhat.com>
 <20130709.023222.767482110746812707.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709.023222.767482110746812707.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 02:32:22AM -0700, David Miller wrote:
> 
> I don't see patch #1 in v2 of this series.

It's there now:
http://patchwork.ozlabs.org/patch/257692/
